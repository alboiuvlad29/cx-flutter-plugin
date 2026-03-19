import 'package:cx_flutter_plugin/cx_session_replay_options.dart';
import 'package:cx_flutter_plugin/cx_types.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'cx_exporter_options.dart';
import 'cx_flutter_plugin_method_channel.dart';

abstract class CxFlutterPluginPlatform extends PlatformInterface {
  /// Constructs a CxFlutterPluginPlatform.
  CxFlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static CxFlutterPluginPlatform _instance = MethodChannelCxFlutterPlugin();

  /// The default instance of [CxFlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelCxFlutterPlugin].
  static CxFlutterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CxFlutterPluginPlatform] when
  /// they register themselves.
  static set instance(CxFlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> initSdk(CXExporterOptions options) {
    throw UnimplementedError('initSdk() has not been implemented.');
  }

  Future<String?> setNetworkRequestContext(Map<String, dynamic> networkRequestContext) {
    throw UnimplementedError('setNetworkRequestContext() has not been implemented.');
  }

  Future<String?> setUserContext(UserMetadata userContext) {
    throw UnimplementedError('setUserContext() has not been implemented.');
  }

  Future<String?> setLabels(Map<String, dynamic> labels) {
    throw UnimplementedError('setLabels() has not been implemented.');
  }

  Future<String?> log(CxLogSeverity severity, String message, Map<String, dynamic> data) {
    throw UnimplementedError('log() has not been implemented.');
  }

  Future<String?> reportError(String message, Map<String, dynamic>? data, String? stackTrace) {
    throw UnimplementedError('reportError() has not been implemented.');
  }

  Future<String?> shutdown() {
    throw UnimplementedError('shutdown() has not been implemented.');
  }  

  Future<String?> sendCustomMeasurement(String name, double value) {
    throw UnimplementedError('sendCustomMeasurement() has not been implemented.');
  }
   
  Future<String?> setView(String name) {
    throw UnimplementedError('setView() has not been implemented.');
  } 

  Future<String?> sendCxSpanData(Function(Map<String, dynamic>) cxSpan) {
    throw UnimplementedError('sendCxSpanData() has not been implemented.');
  }

  Future<Map<String, dynamic>?> getLabels() {
    throw UnimplementedError('getLables() has not been implemented.');
  }

  Future<bool> isInitialized() {
    throw UnimplementedError('isInitialized() has not been implemented.');
  }

  Future<String?> getSessionId() {
    throw UnimplementedError('getSessionId() has not been implemented.');
  }

  Future<String?> setApplicationContext(String applicationName, String applicationVersion) {
    throw UnimplementedError('setApplicationContext() has not been implemented.');
  }

  // session replay methods
  Future<String?> initializeSessionReplay(CXSessionReplayOptions options) async {
    throw UnimplementedError('initializeSessionReplay() has not been implemented.');
  }

  Future<bool> isRecording() async {
    throw UnimplementedError('isRecording() has not been implemented.');
  }

  Future<bool> isSessionReplayInitialized() async {
    throw UnimplementedError('isSessionReplayInitialized() has not been implemented.');
  }
  
  Future<void> shutdownSessionReplay() async {
    throw UnimplementedError('shutdownSessionReplay() has not been implemented.');
  }

  Future<void> startSessionRecording() async {
    throw UnimplementedError('startSessionRecording() has not been implemented.');
  }

  Future<void> stopSessionRecording() async {
    throw UnimplementedError('stopSessionRecording() has not been implemented.');
  }

  Future<void> captureScreenshot() async {
    throw UnimplementedError('captureScreenshot() has not been implemented.');
  }

  Future<void> registerMaskRegion(String id) async {
    throw UnimplementedError('registerMaskRegion() has not been implemented.');
  }

  Future<void> unregisterMaskRegion(String id) async {
    throw UnimplementedError('unregisterMaskRegion() has not been implemented.');
  }

  Future<String?> getSessionReplayFolderPath() async {
    throw UnimplementedError('getSessionReplayFolderPath() has not been implemented.');
  }

  Future<String?> setUserInteraction(Map<String, dynamic> interactionDataContext) {
    throw UnimplementedError('setUserInteraction() has not been implemented.');
  }
}
