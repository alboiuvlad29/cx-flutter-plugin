import 'package:cx_flutter_plugin/cx_domain.dart';
import 'package:cx_flutter_plugin/cx_types.dart';

class CXExporterOptions {
  // Configuration for user context
  UserMetadata? userContext;

  // Turns on/off internal debug logging
  final bool debug;

  // Applies for Fetch URLs. URLs that match that regex will not be traced.
  final List<String>? ignoreUrls;

  // A pattern for error messages which should not be sent to Coralogix. By default, all errors will be sent.
  final List<String>? ignoreErrors;

  // Coralogix account domain
  final CXDomain coralogixDomain;

  // Coralogix token
  String publicKey;

  // Environment
  final String environment;

  // Application name
  final String application;

  // Application version
  final String version;

  final String? proxyUrl;

  Map<String, dynamic>? labels;

  // Number between 0-100 as a precentage of SDK should be init.
  final int sdkSampler;

  // The timeinterval the SDK will run the FPS sampling in an hour. default is every 1 minute.
  final int mobileVitalsFPSSamplingRate;

  // A list of instruments that you wish to switch off during runtime. all instrumentations are active by default.
  Map<String, bool>? instrumentations;

  // Determines whether the SDK should collect the user's IP address and corresponding geolocation data. Defaults to true.
  final bool collectIPData;

  // Enable event access and modification before sending to Coralogix, supporting content modification, and event discarding.
  // When null (default), events are sent directly without Dart-side processing, avoiding platform channel overhead.
  final BeforeSendResult Function(EditableCxRumEvent event)? beforeSend;

  // When set to `false`, disables Coralogix's automatic method swizzling.
  // Swizzling is used to auto-instrument various system behaviors (e.g., view controller lifecycle,
  // app delegate events, network calls). Disabling it gives you full manual control over instrumentation.
  //
  // - Remark: As of the current Coralogix SDK version, `enableSwizzling = false` only disables `NSURLSession` instrumentation.
  final bool enableSwizzling;

  // Add trace context propagation in headers across service boundaries
  Map<String, dynamic>? traceParentInHeader;

  CXExporterOptions({
    required this.coralogixDomain,
    this.userContext,
    required this.environment,
    required this.application,
    required this.version,
    required this.publicKey,
    this.ignoreUrls,
    this.ignoreErrors,
    this.proxyUrl,
    this.labels,
    this.sdkSampler = 100,
    this.mobileVitalsFPSSamplingRate = 300,
    this.instrumentations,
    this.collectIPData = true,
    this.debug = false,
    this.beforeSend,
    required this.enableSwizzling,
    this.traceParentInHeader,
  });

  Map<String, dynamic> toMap() {
    return {
      'userContext': userContext?.toJson(),
      'debug': debug,
      'ignoreUrls': ignoreUrls,
      'ignoreErrors': ignoreErrors,
      'coralogixDomain': coralogixDomain.url,
      'publicKey': publicKey,
      'environment': environment,
      'application': application,
      'version': version,
      'proxyUrl': proxyUrl,
      'labels': labels,
      'sdkSampler': sdkSampler,
      'mobileVitalsFPSSamplingRate': mobileVitalsFPSSamplingRate,
      'instrumentations': instrumentations,
      'collectIPData': collectIPData,
      'enableSwizzling': enableSwizzling,
      'traceParentInHeader': traceParentInHeader,
      'hasBeforeSend': beforeSend != null,
    };
  }
}
