import 'package:cx_flutter_plugin/cx_exporter_options.dart';
import 'package:cx_flutter_plugin/cx_session_replay_options.dart';
import 'package:cx_flutter_plugin/cx_types.dart';
import 'package:cx_flutter_plugin/cx_instrumentation_type.dart';
import 'package:cx_flutter_plugin/cx_interaction_tracker.dart';

import 'cx_flutter_plugin_platform_interface.dart';

class CxFlutterPlugin {
  // Global storage for options
  static CXExporterOptions? _globalOptions;

  // Getter to access global options
  static CXExporterOptions? get globalOptions => _globalOptions;

  // Check if options are available
  static bool get hasGlobalOptions => _globalOptions != null;

  /// User interaction logic for hybrid (Flutter):
  /// - [userInteraction: true]  → Dart detects click/scroll/swipe; native is always
  ///   passed false to avoid duplicate events.
  /// - [userInteraction: false] → No detection on Dart; native is still passed false.
  static Future<String?> initSdk(CXExporterOptions options) async {
    // Save options globally for later use
    _globalOptions = options;
    
    // Initialize platform SDK first (iOS/Android always receive userActions: false)
    final result = await CxFlutterPluginPlatform.instance.initSdk(options);
    
    // Only run Dart-side interaction tracking when user opted in.
    // result is non-null on successful platform init; null when platform init failed (exception propagates or platform returned null).
    if (result != null) {
      final userActionsEnabled = options.instrumentations?[CXInstrumentationType.userActions.value] == true;
      if (userActionsEnabled) {
        CxInteractionTracker.initialize(debug: options.debug);
      }
    }
    
    return result;
  }

  static Future<String?> setNetworkRequestContext(
      Map<String, dynamic> networkRequestContext) {
      return CxFlutterPluginPlatform.instance
        .setNetworkRequestContext(networkRequestContext);
  }

  static Future<String?> setUserContext(UserMetadata userContext) {
    return CxFlutterPluginPlatform.instance
        .setUserContext(userContext);
  }

  static  Future<String?> setLabels(Map<String, dynamic> labels) {
     return CxFlutterPluginPlatform.instance.setLabels(labels);
  }

  static Future<String?> reportError(String message, Map<String, dynamic>? data, String? stackTrace) {
    return CxFlutterPluginPlatform.instance.reportError(message, data, stackTrace);
  }

  static Future<String?> log(CxLogSeverity severity, String message, Map<String, dynamic> data) {
    return CxFlutterPluginPlatform.instance.log(severity, message, data);
  }

  static Future<String?> sendCustomMeasurement(String name, double value) {
    return CxFlutterPluginPlatform.instance.sendCustomMeasurement(name, value);
  }

  static Future<String?> shutdown() {
    // Stop interaction tracking
    CxInteractionTracker.shutdown();
    // Clear global options on shutdown
    _globalOptions = null;
    return CxFlutterPluginPlatform.instance.shutdown();
  }  

  static Future<String?> setView(String name) {
    return CxFlutterPluginPlatform.instance.setView(name);
  } 

  static Future<String?> sendCxSpanData(Function(Map<String, dynamic>) cxSpan) {
    return CxFlutterPluginPlatform.instance.sendCxSpanData(cxSpan);
  }

  static Future<Map<String, dynamic>?> getLabels() {
    return CxFlutterPluginPlatform.instance.getLabels();
  }

  static Future<bool> isInitialized() {
    return CxFlutterPluginPlatform.instance.isInitialized();
  }

  static Future<String?> getSessionId() {
    return CxFlutterPluginPlatform.instance.getSessionId();
  }

  static Future<String?> setApplicationContext(String applicationName, String applicationVersion) {
    return CxFlutterPluginPlatform.instance.setApplicationContext(applicationName, applicationVersion);
  }

  // session replay methods
  static Future<String?> initializeSessionReplay(CXSessionReplayOptions options) {
    return CxFlutterPluginPlatform.instance.initializeSessionReplay(options);
  }

  static Future<bool> isSessionReplayInitialized() {
    return CxFlutterPluginPlatform.instance.isSessionReplayInitialized();
  }

  static Future<bool> isRecording() {
    return CxFlutterPluginPlatform.instance.isRecording();
  }

  static Future<void> shutdownSessionReplay() {
    return CxFlutterPluginPlatform.instance.shutdownSessionReplay();
  }

  static Future<void> startSessionRecording() {
    return CxFlutterPluginPlatform.instance.startSessionRecording();
  }

  static Future<void> stopSessionRecording() {
    return CxFlutterPluginPlatform.instance.stopSessionRecording();
  }
  
  static Future<void> captureScreenshot() {
    return CxFlutterPluginPlatform.instance.captureScreenshot();
  }

  static Future<void> registerMaskRegion(String id) {
    return CxFlutterPluginPlatform.instance.registerMaskRegion(id);
  }

  static Future<void> unregisterMaskRegion(String id) {
    return CxFlutterPluginPlatform.instance.unregisterMaskRegion(id);
  }

  static Future<String?> getSessionReplayFolderPath() {
    return CxFlutterPluginPlatform.instance.getSessionReplayFolderPath();
  }

  /// Sets user interaction context and reports it to the native SDK.
  /// 
  /// This is typically called automatically by [CxInteractionTracker],
  /// but can also be called manually for custom interaction tracking.
  static Future<String?> setUserInteraction(
      Map<String, dynamic> interactionDataContext) {
    return CxFlutterPluginPlatform.instance
        .setUserInteraction(interactionDataContext);
  }
}
