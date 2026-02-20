import 'dart:async';

import 'package:cx_flutter_plugin/cx_exporter_options.dart';
import 'package:cx_flutter_plugin/cx_instrumentation_type.dart';
import 'package:cx_flutter_plugin/cx_plugin_info.dart';
import 'package:cx_flutter_plugin/cx_record_first_frame_render_time.dart';
import 'package:cx_flutter_plugin/cx_session_replay_masking.dart';
import 'package:cx_flutter_plugin/cx_session_replay_options.dart';
import 'package:cx_flutter_plugin/cx_types.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cx_flutter_plugin_platform_interface.dart';

/// An implementation of [CxFlutterPluginPlatform] that uses method channels.
class MethodChannelCxFlutterPlugin extends CxFlutterPluginPlatform {
  /// The method channel used to interact with the native platform.
  ///

  @visibleForTesting
  final methodChannel = const MethodChannel('cx_flutter_plugin');

  static const EventChannel _eventChannel = EventChannel('cx_flutter_plugin/onBeforeSend');

  StreamSubscription? _eventSubscription;

  EditableCxRumEvent? Function(EditableCxRumEvent)? _beforeSendCallback;

  WarmStartTracker? _warmStartTracker;

  @override
  Future<String?> initSdk(CXExporterOptions options) async {
    var arguments = options.toMap();
    // Remove beforeSend from arguments as it cannot be serialized
    arguments.remove('beforeSend');
    arguments['hasBeforeSend'] = options.beforeSend != null;

    arguments['pluginVersion'] = PluginInfo.version;

    if (arguments['instrumentations'] is Map &&
        arguments['instrumentations'][CXInstrumentationType.mobileVitals.value] == true) {
      try {
        _warmStartTracker = WarmStartTracker();
        _warmStartTracker?.init(methodChannel);
      } catch (e) {
        debugPrint('Failed to initialize WarmStartTracker: $e');
        _warmStartTracker = null;
      }
    }

    final version = await methodChannel.invokeMethod<String>('initSdk', arguments);

    if (options.beforeSend != null) {
      _beforeSendCallback = options.beforeSend;
      _startListening();
    }

    return version;
  }

  @override
  Future<String?> setNetworkRequestContext(Map<String, dynamic> networkRequestContext) async {
    try {
      final version = await methodChannel.invokeMethod<String>('setNetworkRequestContext', networkRequestContext);
      return version;
    } on PlatformException {
      return null;
    }
  }

  @override
  Future<String?> setUserContext(UserMetadata userContext) async {
    var arguments = userContext.toJson();
    final String? version = await methodChannel.invokeMethod<String>('setUserContext', arguments);
    return version;
  }

  @override
  Future<String?> setLabels(Map<String, dynamic> labels) async {
    final version = await methodChannel.invokeMethod<String>('setLabels', labels);
    return version;
  }

  @override
  Future<String?> log(CxLogSeverity severity, String message, Map<String, dynamic> data) async {
    try {
      final arguments = {
        'severity': severity.name,
        'message': message,
        'data': data,
      };

      if (arguments['message'] == null || arguments['message'].toString().isEmpty) {
        throw ArgumentError('Message cannot be null or empty');
      }

      final version = await methodChannel.invokeMethod<String>('log', arguments);
      return version;
    } on PlatformException catch (e) {
      debugPrint('Error in log method: $e');
      return null;
    }
  }

  @override
  Future<String?> getSessionId() async {
    final version = await methodChannel.invokeMethod<String>('getSessionId');
    return version;
  }

  @override
  Future<String?> setApplicationContext(String applicationName, String applicationVersion) async {
    final arguments = {'applicationName': applicationName, 'applicationVersion': applicationVersion};
    final version = await methodChannel.invokeMethod<String>('setApplicationContext', arguments);
    return version;
  }

  @override
  Future<String?> reportError(String message, Map<String, dynamic>? data, String? stackTrace) async {
    Map<String, Object?> arguments;
    if (stackTrace != null) {
      arguments = {'message': message, 'data': data, 'stackTrace': stackTrace};
    } else {
      arguments = {'message': message, 'data': data};
    }
    final version = await methodChannel.invokeMethod<String>('reportError', arguments);
    return version;
  }

  @override
  Future<String?> shutdown() async {
    _warmStartTracker?.dispose();
    final version = await methodChannel.invokeMethod<String>('shutdown');
    return version;
  }

  @override
  Future<String?> setView(String name) async {
    var arguments = {'viewName': name};

    try {
      final version = await methodChannel.invokeMethod<String>('setView', arguments);
      return version;
    } on PlatformException {
      return null;
    }
  }

  @override
  Future<String?> sendCustomMeasurement(String name, double value) async {
    var arguments = {'name': name, 'value': value};
    try {
      final version = await methodChannel.invokeMethod<String>('sendCustomMeasurement', arguments);
      return version;
    } on PlatformException {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getLabels() async {
    try {
      final labels = await methodChannel.invokeMethod<Map<dynamic, dynamic>>('getLabels');
      if (labels == null) return null;
      return Map<String, dynamic>.from(labels);
    } on PlatformException catch (e) {
      debugPrint('Error getting labels: $e');
      return null;
    }
  }

  @override
  Future<bool> isInitialized() async {
    final isInitialized = await methodChannel.invokeMethod<bool>('isInitialized');
    return isInitialized ?? false;
  }

  Map<String, dynamic> _convertMap(Map map) {
    return Map<String, dynamic>.fromEntries(
      map.entries.map((entry) {
        final value = entry.value;
        if (value is Map) {
          return MapEntry(entry.key.toString(), _convertMap(value));
        } else if (value is List) {
          return MapEntry(
              entry.key.toString(),
              value.map((item) {
                if (item is Map) {
                  return _convertMap(item);
                }
                return item;
              }).toList());
        }
        return MapEntry(entry.key.toString(), value);
      }),
    );
  }

  Map<String, dynamic>? _extractEventMap(dynamic fullEvent) {
    try {
      final fullEventMap = Map<String, dynamic>.from(fullEvent);
      final textMap = fullEventMap['text'];
      if (textMap is! Map) {
        debugPrint('Invalid "text" structure in event: $fullEventMap');
        return null;
      }

      final cxRumRaw = textMap['cx_rum'];
      if (cxRumRaw is! Map) {
        debugPrint('Invalid or missing "cx_rum": $textMap');
        return null;
      }

      return _convertMap(cxRumRaw);
    } catch (e) {
      debugPrint('Error extracting event map: $e');
      return null;
    }
  }

  Map<String, dynamic>? _processEvent(Map<String, dynamic> eventMap) {
    try {
      final editableEvent = EditableCxRumEvent.fromJson(eventMap);
      final callback = _beforeSendCallback;
      if (callback == null) return null;
      final result = callback(editableEvent);
      if (result == null) return null;

      // Convert result to JSON but only include fields that existed in the original eventMap
      final resultJson = result.toJson();
      final filteredJson =
          Map<String, dynamic>.fromEntries(resultJson.entries.where((entry) => eventMap.containsKey(entry.key)));

      return {'cx_rum': filteredJson};
    } catch (e, stackTrace) {
      debugPrint('Error parsing event: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('Raw event data: $eventMap');
      return null;
    }
  }

  Future<void> _handleEvents(dynamic events) async {
    final List<Map<String, dynamic>> processedEvents = [];

    for (final fullEvent in events) {
      try {
        // debugPrint('fullEvent before parsing: $fullEvent');

        final fullEventTyped = Map<String, dynamic>.from(fullEvent);
        final eventMap = _extractEventMap(fullEventTyped);
        if (eventMap == null) continue;

        // processedEvent contains a text { cx_rum: { ... } } object
        final processedEvent = _processEvent(eventMap);
        if (processedEvent != null) {
          fullEventTyped["text"] = processedEvent;
          processedEvents.add(fullEventTyped);
        }
      } catch (e, stackTrace) {
        debugPrint('Stack trace: $stackTrace');
        debugPrint('Error in beforeSend callback: $e');
      }
    }

    if (processedEvents.isNotEmpty) {
      try {
        await methodChannel.invokeMethod('sendCxSpanData', processedEvents);
      } on PlatformException catch (e) {
        debugPrint('Failed to send processed events: $e');
      }
    }
  }

  void _startListening() {
    if (_eventSubscription != null) return;

    _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
      (dynamic events) async {
        if (events is! List) return;
        await _handleEvents(events);
      },
      onError: (err) {
        debugPrint('onBeforeSend stream error: $err');
      },
    );
  }

  void stopListening() {
    _eventSubscription?.cancel();
    _eventSubscription = null;
  }

  void dispose() {
    _warmStartTracker?.dispose();
  }

  // session replay methods
  @override
  Future<String?> initializeSessionReplay(CXSessionReplayOptions options) async {
    try {
      final arguments = options.toMap();
      final result = await methodChannel.invokeMethod<String>('initializeSessionReplay', arguments);

      SessionReplayMasking.initialize();

      return result;
    } on PlatformException catch (e) {
      debugPrint('Error initializing session replay: $e');
      return null;
    }
  }

  @override
  Future<bool> isSessionReplayInitialized() async {
    final isSessionReplayInitialized = await methodChannel.invokeMethod<bool>('isSessionReplayInitialized');
    return isSessionReplayInitialized ?? false;
  }

  @override
  Future<bool> isRecording() async {
    final isRecording = await methodChannel.invokeMethod<bool>('isRecording');
    return isRecording ?? false;
  }

  @override
  Future<void> shutdownSessionReplay() async {
    await methodChannel.invokeMethod<void>('shutdownSessionReplay');
  }

  @override
  Future<void> startSessionRecording() async {
    await methodChannel.invokeMethod<void>('startSessionRecording');
  }

  @override
  Future<void> stopSessionRecording() async {
    await methodChannel.invokeMethod<void>('stopSessionRecording');
  }

  @override
  Future<void> captureScreenshot() async {
    await methodChannel.invokeMethod<void>('captureScreenshot');
  }

  @override
  Future<void> registerMaskRegion(String id) async {
    try {
      await methodChannel.invokeMethod<void>('registerMaskRegion', id);
    } catch (_) {
      // Swallow errors; masking is best-effort only.
    }
  }

  @override
  Future<void> unregisterMaskRegion(String id) async {
    try {
      await methodChannel.invokeMethod<void>('unregisterMaskRegion', id);
    } catch (_) {
      // Best-effort.
    }
  }

  @override
  Future<String?> getSessionReplayFolderPath() async {
    return await methodChannel.invokeMethod<String?>('getSessionReplayFolderPath');
  }
}
