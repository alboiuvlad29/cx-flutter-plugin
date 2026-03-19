import 'package:json_annotation/json_annotation.dart';

part 'cx_types.g.dart';

enum CoralogixEventType {
  error,
  @JsonValue('network-request')
  networkRequest,
  log,
  @JsonValue('user-interaction')
  userInteraction,
  webVitals,
  longTask,
  resources,
  internal,
  navigation,
  @JsonValue('mobile-vitals')
  mobileVitals,
  @JsonValue('life-cycle')
  lifeCycle,
  @JsonValue('custom-measurement')
  customMeasurement,
  screenshot
}

enum CxLogSeverity {
  /// Default value when native SDK sends severity 0 (no severity specified).
  @JsonValue(0)
  unset,
  @JsonValue(1)
  debug,
  @JsonValue(2)
  verbose,
  @JsonValue(3)
  info,
  @JsonValue(4)
  warn,
  @JsonValue(5)
  error,
  @JsonValue(6)
  critical,
}

@JsonSerializable()
class VersionMetaData {
  @JsonKey(name: 'app_name')
  String appName;

  @JsonKey(name: 'app_version')
  String appVersion;

  VersionMetaData({
    required this.appName,
    required this.appVersion,
  });

  factory VersionMetaData.fromJson(Map<String, dynamic> json) {
    try {
      // Ensure we're working with String values
      final appName = json['app_name']?.toString() ?? '';
      final appVersion = json['app_version']?.toString() ?? '';

      return VersionMetaData(
        appName: appName,
        appVersion: appVersion,
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'app_name': appName,
      'app_version': appVersion,
    };
  }
}

@JsonSerializable()
class MobileSdk {
  @JsonKey(name: 'sdk_version')
  final String sdkVersion;

  @JsonKey(name: 'framework')
  final String framework;

  @JsonKey(name: 'os')
  final String operatingSystem;

  MobileSdk({
    required this.sdkVersion,
    required this.framework,
    required this.operatingSystem,
  });

  factory MobileSdk.fromJson(Map<String, dynamic> json) =>
      _$MobileSdkFromJson(json);

  Map<String, dynamic> toJson() => _$MobileSdkToJson(this);
}

@JsonSerializable()
class UserMetadata {
  @JsonKey(name: 'user_id')
  String userId;

  @JsonKey(name: 'user_name')
  String? userName;

  @JsonKey(name: 'user_email')
  String? userEmail;

  @JsonKey(name: 'user_metadata')
  Map<String, dynamic>? userMetadata;

  UserMetadata({
    required this.userId,
    this.userName,
    this.userEmail,
    this.userMetadata,
  });

  factory UserMetadata.fromJson(Map<String, dynamic> json) =>
      _$UserMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$UserMetadataToJson(this);
}

@JsonSerializable()
class SessionContext extends UserMetadata {
  @JsonKey(name: 'session_id')
  String? sessionId;

  @JsonKey(name: 'session_creation_date')
  num? sessionCreationDate;

  @JsonKey(name: 'hasRecording')
  bool hasRecording;

  SessionContext({
    required super.userId,
    super.userName,
    super.userEmail,
    super.userMetadata,
    this.sessionId,
    this.sessionCreationDate,
    this.hasRecording = false,
  });

  factory SessionContext.fromJson(Map<String, dynamic> json) =>
      _$SessionContextFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SessionContextToJson(this);
}

@JsonSerializable()
class DeviceState {
  String? battery;

  @JsonKey(name: 'network_type')
  String? networkType;

  DeviceState({this.battery, this.networkType});

  factory DeviceState.fromJson(Map<String, dynamic> json) =>
      _$DeviceStateFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceStateToJson(this);
}

/// Device context. Serializes with [toJson] using keys expected by the schema
/// validator (os, osVersion). [fromJson] accepts both validator keys and
/// native keys (operating_system, os_version) so events from native round-trip correctly.
@JsonSerializable()
class DeviceContext {
  String? device;

  @JsonKey(name: 'device_name')
  String? deviceName;

  bool? emulator;

  @JsonKey(name: 'operating_system')
  String? os;

  @JsonKey(name: 'os_version')
  dynamic osVersion;

  @JsonKey(name: 'network_connection_type')
  String? networkConnectionType;

  @JsonKey(name: 'network_connection_subtype')
  String? networkConnectionSubtype;

  @JsonKey(name: 'user_agent')
  String? userAgent;

  DeviceContext({
    this.device,
    this.deviceName,
    this.emulator,
    this.os,
    this.osVersion,
    this.networkConnectionType,
    this.networkConnectionSubtype,
    this.userAgent,
  });

  /// Accepts both validator keys (os, osVersion) and native keys (operating_system, os_version).
  factory DeviceContext.fromJson(Map<String, dynamic> json) {
    final os = json['operating_system'] ?? json['os'];
    final osVersion = json['os_version'] ?? json['osVersion'];
    return DeviceContext(
      device: json['device'] as String?,
      deviceName: json['device_name'] as String?,
      emulator: json['emulator'] as bool?,
      os: os is String ? os : os?.toString(),
      osVersion: osVersion,
      networkConnectionType: json['network_connection_type'] as String?,
      networkConnectionSubtype: json['network_connection_subtype'] as String?,
      userAgent: json['user_agent'] as String?,
    );
  }

  /// Emits keys expected by the schema validator (os, osVersion) so validation passes.
  /// Omits operating_system, os_version, network_connection_subtype (validator forbids),
  /// and omits networkConnectionType and userAgent from outgoing payload by design.
  /// Only includes os/osVersion when non-null to avoid empty strings that may fail validation.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'device': device,
      'device_name': deviceName,
      'emulator': emulator,
    };
    if (os != null) map['os'] = os!;
    if (osVersion != null) map['osVersion'] = osVersion.toString();
    return map;
  }
}

@JsonSerializable()
class EventContext {
  final CoralogixEventType type;
  final String? source;
  @JsonKey(includeIfNull: true)
  final CxLogSeverity? severity;

  EventContext({
    required this.type,
    this.source,
    this.severity,
  });

  factory EventContext.fromJson(Map<String, dynamic> json) =>
      _$EventContextFromJson(json);

  Map<String, dynamic> toJson() => _$EventContextToJson(this);
}

@JsonSerializable()
class ErrorContext {
  String? domain;
  String? code;

  @JsonKey(name: 'error_message')
  String? errorMessage;

  @JsonKey(name: 'user_info')
  String? userInfo;

  @JsonKey(name: 'original_stacktrace')
  List<Map<String, dynamic>>? originalStacktrace;

  @JsonKey(name: 'error_type')
  String? errorType;

  @JsonKey(name: 'is_crashed')
  bool? isCrashed;

  @JsonKey(name: 'event_type')
  String? eventType;

  @JsonKey(name: 'error_context')
  String? errorContext;

  @JsonKey(name: 'crash_timestamp')
  String? crashTimestamp;

  @JsonKey(name: 'process_name')
  String? processName;

  @JsonKey(name: 'application_identifier')
  String? applicationIdentifier;

  @JsonKey(name: 'triggered_by_thread')
  String? triggeredByThread;

  @JsonKey(name: 'base_address')
  String? baseAddress;

  String? arch;
  List<Map<String, dynamic>>? threads;

  @JsonKey(name: 'exception_type')
  String? exceptionType;

  ErrorContext({
    this.domain,
    this.code,
    this.errorMessage,
    this.userInfo,
    this.originalStacktrace,
    this.errorType,
    this.isCrashed,
    this.eventType,
    this.errorContext,
    this.crashTimestamp,
    this.processName,
    this.applicationIdentifier,
    this.triggeredByThread,
    this.baseAddress,
    this.arch,
    this.threads,
    this.exceptionType,
  });

  factory ErrorContext.fromJson(Map<String, dynamic> json) =>
      _$ErrorContextFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorContextToJson(this);
}

@JsonSerializable()
class LogContext {
  String message;
  dynamic data;

  LogContext({required this.message, this.data});

  factory LogContext.fromJson(Map<String, dynamic> json) =>
      _$LogContextFromJson(json);

  Map<String, dynamic> toJson() => _$LogContextToJson(this);
}

@JsonSerializable()
class MeasurementContext {
  String name;
  double value;

  MeasurementContext({required this.name, required this.value});

  factory MeasurementContext.fromJson(Map<String, dynamic> json) =>
      _$MeasurementContextFromJson(json);

  Map<String, dynamic> toJson() => _$MeasurementContextToJson(this);
}

class InteractionContext {
    @JsonKey(name: 'element_id')
    String? elementId;

    @JsonKey(name: 'event_name')
    String? eventName;

    @JsonKey(name: 'target_element')
    String? targetElement;

    @JsonKey(name: 'element_classes')
    String? elementClasses;

    @JsonKey(name: 'target_element_inner_text')
    String? targetElementInnerText;

    @JsonKey(name: 'scroll_direction')
    String? scrollDirection;

    final Map<String, dynamic>? attributes;

    InteractionContext({
      this.elementId,
      this.eventName,
      this.targetElement,
      this.elementClasses,
      this.targetElementInnerText,
      this.scrollDirection,
      this.attributes,
    });

    factory InteractionContext.fromJson(Map<String, dynamic> json) {
      return InteractionContext(
        elementId: (json['element_id'] ?? json['target_id']) as String?,
        eventName: json['event_name'] as String?,
        targetElement: json['target_element'] as String?,
        elementClasses: json['element_classes'] as String?,
        targetElementInnerText: json['target_element_inner_text'] as String?,
        scrollDirection: json['scroll_direction'] as String?,
        attributes: json['attributes'] != null
            ? Map<String, dynamic>.from(json['attributes'] as Map)
            : null,
      );
    }

    /// Serializes to the same keys as iOS InteractionContext.getDictionary():
    /// event_name, target_element, element_classes, element_id, target_id, target_element_inner_text, scroll_direction, attributes.
    /// Emits both element_id and target_id when [elementId] is set so Android (target_id) and legacy (element_id) both work.
    /// Optional fields are only included when non-null to match the SDK.
    Map<String, dynamic> toJson() {
      final map = <String, dynamic>{};
      if (eventName != null) map['event_name'] = eventName;
      if (targetElement != null) map['target_element'] = targetElement;
      if (elementId != null) {
        map['element_id'] = elementId;
        map['target_id'] = elementId;
      }
      if (elementClasses != null) map['element_classes'] = elementClasses;
      if (targetElementInnerText != null) map['target_element_inner_text'] = targetElementInnerText;
      if (scrollDirection != null) map['scroll_direction'] = scrollDirection;
      if (attributes != null) map['attributes'] = attributes;
      return map;
    }
}
    

@JsonSerializable()
class NetworkRequestContext {
  String method;

  @JsonKey(name: 'status_code')
  int statusCode;

  String url;
  String? fragments;
  String? host;
  String? schema;

  @JsonKey(name: 'status_text')
  String? statusText;

  @JsonKey(
    name: 'response_content_length',
    fromJson: _responseContentLengthFromJson,
  )
  int? responseContentLength;

  int duration;

  @JsonKey(name: 'request_headers')
  Map<String, String>? requestHeaders;

  @JsonKey(name: 'response_headers')
  Map<String, String>? responseHeaders;

  @JsonKey(name: 'request_payload')
  String? requestPayload;

  @JsonKey(name: 'response_payload')
  String? responsePayload;

  NetworkRequestContext({
    required this.method,
    required this.statusCode,
    required this.url,
    this.fragments,
    this.host,
    this.schema,
    this.statusText,
    this.responseContentLength,
    this.duration = 0,
    this.requestHeaders,
    this.responseHeaders,
    this.requestPayload,
    this.responsePayload,
  });

  static int? _responseContentLengthFromJson(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }

  factory NetworkRequestContext.fromJson(Map<String, dynamic> json) =>
      _$NetworkRequestContextFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkRequestContextToJson(this);

}

@JsonSerializable()
class SnapshotContext {
  int timestamp;
  @JsonKey(name: 'errorCount')
  int errorCount;
  @JsonKey(name: 'viewCount')
  int viewCount;
  @JsonKey(name: 'actionCount')
  int actionCount;
  @JsonKey(name: 'hasRecording')
  bool hasRecording;

  SnapshotContext({
    required this.timestamp,
    required this.errorCount,
    required this.viewCount,
    required this.actionCount,
    required this.hasRecording,
  });

  factory SnapshotContext.fromJson(Map<String, dynamic> json) {
    return SnapshotContext(
      timestamp: json['timestamp'] is int
          ? json['timestamp']
          : (json['timestamp'] as num?)?.toInt() ?? 0,
      errorCount: json['errorCount'] is int
          ? json['errorCount'] as int
          : int.tryParse(json['errorCount']?.toString() ?? '0') ?? 0,
      viewCount: json['viewCount'] ?? 0,
      actionCount: json['actionCount'] ?? 0,
      hasRecording: json['hasRecording'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'errorCount': errorCount,
      'viewCount': viewCount,
      'actionCount': actionCount,
      'hasRecording': hasRecording,
    };
  }
}

@JsonSerializable()
class LifeCycleContext {
  @JsonKey(name: 'event_name')
  String? eventName;

  LifeCycleContext({this.eventName});

  factory LifeCycleContext.fromJson(Map<String, dynamic> json) =>
      _$LifeCycleContextFromJson(json);

  Map<String, dynamic> toJson() => _$LifeCycleContextToJson(this);
}

class MobileVitalsContext {
  Map<String, dynamic>? mobileVitalsType;

  MobileVitalsContext({
    this.mobileVitalsType,
  });

  factory MobileVitalsContext.fromJson(Map<String, dynamic> json) {
    // The json may come in different formats:
    // 1. Direct format: {"mobileVitalsType": {...}}
    if (json.containsKey('mobileVitalsType')) {
      final mobileVitalsData = json['mobileVitalsType'];
      if (mobileVitalsData is Map<String, dynamic>) {
        return MobileVitalsContext(
          mobileVitalsType: mobileVitalsData,
        );
      }
    }
    
    return MobileVitalsContext(
      mobileVitalsType: json.isNotEmpty ? json : null,
    );
  }

  Map<String, dynamic> toJson() {
    // If mobileVitalsType exists, return it directly as the JSON structure
    // This matches the native SDK format where mobile_vitals_context is a flat map
    return mobileVitalsType ?? {};
  }
}

@JsonSerializable()
class ViewContext {
  String? view;

  ViewContext({this.view});

  factory ViewContext.fromJson(Map<String, dynamic> json) =>
      _$ViewContextFromJson(json);

  Map<String, dynamic> toJson() => _$ViewContextToJson(this);
}

@JsonSerializable()
class InstrumentationData {
  final OtelResource otelResource;
  final OtelSpan otelSpan;

  InstrumentationData({
    required this.otelResource,
    required this.otelSpan,
  });

  factory InstrumentationData.fromJson(Map<String, dynamic> json) {
    return InstrumentationData(
      otelResource: OtelResource.fromJson(json['otelResource'] as Map<String, dynamic>),
      otelSpan: OtelSpan.fromJson(json['otelSpan'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'otelResource': otelResource.toJson(),
      'otelSpan': otelSpan.toJson(),
    };
  }
}

@JsonSerializable()
class OtelResource {
  final Map<String, dynamic> attributes;

  OtelResource({
    required this.attributes,
  });

  factory OtelResource.fromJson(Map<String, dynamic> json) {
    return OtelResource(
      attributes: Map<String, dynamic>.from(json['attributes'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attributes': attributes,
    };
  }
}

@JsonSerializable()
class OtelSpan {
  final SpanStatus status;
  final String spanId;
  @JsonKey(toJson: _bigIntListToJson, fromJson: _bigIntListFromJson)
  final List<BigInt> endTime;
  final String traceId;
  final List<String> duration;
  final Map<String, dynamic> attributes;
  final int kind;
  final String name;
  @JsonKey(toJson: _bigIntListToJson, fromJson: _bigIntListFromJson)
  final List<BigInt> startTime;

  OtelSpan({
    required this.status,
    required this.spanId,
    required this.endTime,
    required this.traceId,
    required this.duration,
    required this.attributes,
    required this.kind,
    required this.name,
    required this.startTime,
  });

  static List<dynamic> _bigIntListToJson(List<BigInt> list) {
    return list.map((e) => e.toInt()).toList();
  }

  static List<BigInt> _bigIntListFromJson(List<dynamic> list) {
    return list.map((e) => BigInt.from(e)).toList();
  }

  factory OtelSpan.fromJson(Map<String, dynamic> json) {
    return OtelSpan(
      status: SpanStatus.fromJson(json['status'] as Map<String, dynamic>),
      spanId: json['spanId'] as String,
      endTime: _bigIntListFromJson(json['endTime'] as List),
      traceId: json['traceId'] as String,
      duration: List<String>.from(json['duration'] as List),
      attributes: Map<String, dynamic>.from(json['attributes'] as Map),
      kind: json['kind'] as int,
      name: json['name'] as String,
      startTime: _bigIntListFromJson(json['startTime'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.toJson(),
      'spanId': spanId,
      'endTime': _bigIntListToJson(endTime),
      'traceId': traceId,
      'duration': duration,
      'attributes': attributes,
      'kind': kind,
      'name': name,
      'startTime': _bigIntListToJson(startTime),
    };
  }
}

@JsonSerializable()
class SpanStatus {
  final int code;

  SpanStatus({
    required this.code,
  });

  factory SpanStatus.fromJson(Map<String, dynamic> json) {
    return SpanStatus(
      code: json['code'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
    };
  }
}

@JsonSerializable()
class CxRumEvent {
  int timestamp;
  MobileSdk? mobileSdk;
  String platform;
  VersionMetaData? versionMetadata;
  SessionContext? sessionContext;
  DeviceContext? deviceContext;
  DeviceState? deviceState;
  ViewContext? viewContext;
  EventContext? eventContext;
  ErrorContext? errorContext;
  @JsonKey(name: 'interaction_context')
  InteractionContext? interactionContext;
  LogContext? logContext;
  NetworkRequestContext? networkRequestContext;
  SnapshotContext? snapshotContext;
  MobileVitalsContext? mobileVitalsContext;
  LifeCycleContext? lifeCycleContext;
  @JsonKey(name: 'measurement_context')
  MeasurementContext? measurementContext;
  Map<String, dynamic> labels;
  String spanId;
  String traceId;
  String environment;
  bool? isSnapshotEvent;
  InstrumentationData? instrumentationData;
  String fingerPrint;

  @JsonKey(name: 'internal_context')
  InternalContext? internalContext;

  CxRumEvent({
    required this.timestamp,
    this.mobileSdk,
    required this.platform,
    this.versionMetadata,
    this.sessionContext,
    this.deviceContext,
    this.deviceState,
    this.viewContext,
    this.eventContext,
    this.errorContext,
    this.interactionContext,
    this.logContext,
    this.networkRequestContext,
    this.snapshotContext,
    this.mobileVitalsContext,
    this.lifeCycleContext,
    this.measurementContext,
    required this.labels,
    required this.spanId,
    required this.traceId,
    required this.environment,
    this.isSnapshotEvent,
    this.instrumentationData,
    required this.fingerPrint,
    this.internalContext,
  });

  factory CxRumEvent.fromJson(Map<String, dynamic> json) {
    return CxRumEvent(
      timestamp: json['timestamp'] as int,
      mobileSdk: json['mobile_sdk'] == null
          ? null
          : MobileSdk.fromJson(json['mobile_sdk'] as Map<String, dynamic>),
      platform: json['platform'] as String,
      versionMetadata: json['version_metadata'] == null
          ? null
          : VersionMetaData.fromJson(
              json['version_metadata'] as Map<String, dynamic>),
      sessionContext: json['session_context'] == null
          ? null
          : SessionContext.fromJson(
              json['session_context'] as Map<String, dynamic>),
      deviceContext: json['device_context'] == null
          ? null
          : DeviceContext.fromJson(
              json['device_context'] as Map<String, dynamic>),
      deviceState: json['device_state'] == null
          ? null
          : DeviceState.fromJson(json['device_state'] as Map<String, dynamic>),
      viewContext: json['view_context'] == null
          ? null
          : ViewContext.fromJson(json['view_context'] as Map<String, dynamic>),
      eventContext: json['event_context'] == null
          ? null
          : EventContext.fromJson(
              json['event_context'] as Map<String, dynamic>),
      errorContext: json['error_context'] == null
          ? null
          : ErrorContext.fromJson(
              json['error_context'] as Map<String, dynamic>),
      interactionContext: json['interaction_context'] == null
          ? null
          : InteractionContext.fromJson(
              json['interaction_context'] as Map<String, dynamic>),
      logContext: json['log_context'] == null
          ? null
          : LogContext.fromJson(json['log_context'] as Map<String, dynamic>),
      networkRequestContext: json['network_request_context'] == null
          ? null
          : NetworkRequestContext.fromJson(
              json['network_request_context'] as Map<String, dynamic>),
      snapshotContext: json['snapshot_context'] == null
          ? null
          : SnapshotContext.fromJson(
              json['snapshot_context'] as Map<String, dynamic>),
      mobileVitalsContext: json['mobile_vitals_context'] == null
          ? null
          : MobileVitalsContext.fromJson(
              json['mobile_vitals_context'] as Map<String, dynamic>),
      lifeCycleContext: json['life_cycle_context'] == null
          ? null
          : LifeCycleContext.fromJson(
              json['life_cycle_context'] as Map<String, dynamic>),
      measurementContext: json['measurement_context'] == null
          ? null
          : MeasurementContext.fromJson(
              json['measurement_context'] as Map<String, dynamic>),
      labels: Map<String, dynamic>.from(json['labels'] as Map),
      spanId: json['spanId'] as String,
      traceId: json['traceId'] as String,
      environment: json['environment'] as String,
      isSnapshotEvent: json['isSnapshotEvent'] as bool?,
      instrumentationData: json['instrumentation_data'] == null
          ? null
          : InstrumentationData.fromJson(json['instrumentation_data'] as Map<String, dynamic>),
      fingerPrint: json['fingerPrint'] as String? ?? '',
      internalContext: json['internal_context'] == null
          ? null
          : InternalContext.fromJson(json['internal_context'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'mobile_sdk': mobileSdk?.toJson(),
      'platform': platform,
      'version_metadata': versionMetadata?.toJson(),
      'session_context': sessionContext?.toJson(),
      'device_context': deviceContext?.toJson(),
      'device_state': deviceState?.toJson(),
      'view_context': viewContext?.toJson(),
      'event_context': eventContext?.toJson(),
      'error_context': errorContext?.toJson(),
      'interaction_context': interactionContext?.toJson(),
      'log_context': logContext?.toJson(),
      'network_request_context': networkRequestContext?.toJson(),
      'snapshot_context': snapshotContext?.toJson(),
      'mobile_vitals_context': mobileVitalsContext?.toJson(),
      'life_cycle_context': lifeCycleContext?.toJson(),
      'measurement_context': measurementContext?.toJson(),
      'labels': labels,
      'spanId': spanId,
      'traceId': traceId,
      'environment': environment,
      'isSnapshotEvent': isSnapshotEvent,
      'instrumentation_data': instrumentationData?.toJson(),
      'fingerPrint': fingerPrint,
      'internal_context': internalContext?.toJson(),
    };
  }
}

@JsonSerializable()
class EditableCxRumEvent extends CxRumEvent {
  EditableCxRumEvent({
    required super.platform,
    super.versionMetadata,
    required super.timestamp,
    super.mobileSdk,
    super.sessionContext,
    super.deviceContext,
    super.deviceState,
    super.viewContext,
    super.eventContext,
    super.errorContext,
    super.interactionContext,
    super.logContext,
    super.networkRequestContext,
    super.snapshotContext,
    super.mobileVitalsContext,
    super.lifeCycleContext,
    super.measurementContext,
    required super.labels,
    required super.spanId,
    required super.traceId,
    required super.environment,
    super.isSnapshotEvent,
    super.instrumentationData,
    required super.fingerPrint,
    super.internalContext,
  });

  factory EditableCxRumEvent.fromJson(Map<String, dynamic> json) {
    return EditableCxRumEvent(
      timestamp: json['timestamp'] as int,
      platform: json['platform'] as String,
      mobileSdk: json.containsKey('mobile_sdk') && json['mobile_sdk'] != null
          ? MobileSdk.fromJson(Map<String, dynamic>.from(json['mobile_sdk']))
          : null,
      versionMetadata: json.containsKey('version_metadata') &&
              json['version_metadata'] != null
          ? VersionMetaData.fromJson(
              Map<String, dynamic>.from(json['version_metadata']))
          : null,
      sessionContext:
          json.containsKey('session_context') && json['session_context'] != null
              ? SessionContext.fromJson(
                  Map<String, dynamic>.from(json['session_context']))
              : null,
      deviceContext:
          json.containsKey('device_context') && json['device_context'] != null
              ? DeviceContext.fromJson(
                  Map<String, dynamic>.from(json['device_context']))
              : null,
      deviceState:
          json.containsKey('device_state') && json['device_state'] != null
              ? DeviceState.fromJson(
                  Map<String, dynamic>.from(json['device_state']))
              : null,
      viewContext:
          json.containsKey('view_context') && json['view_context'] != null
              ? ViewContext.fromJson(
                  Map<String, dynamic>.from(json['view_context']))
              : null,
      eventContext:
          json.containsKey('event_context') && json['event_context'] != null
              ? EventContext.fromJson(
                  Map<String, dynamic>.from(json['event_context']))
              : null,
      errorContext:
          json.containsKey('error_context') && json['error_context'] != null
              ? ErrorContext.fromJson(
                  Map<String, dynamic>.from(json['error_context']))
              : null,
      interactionContext:
        json.containsKey('interaction_context') && json['interaction_context'] != null
              ? InteractionContext.fromJson(
                  Map<String, dynamic>.from(json['interaction_context']))
              : null,
      logContext: json.containsKey('log_context') && json['log_context'] != null
          ? LogContext.fromJson(Map<String, dynamic>.from(json['log_context']))
          : null,
      networkRequestContext: json.containsKey('network_request_context') &&
              json['network_request_context'] != null
          ? NetworkRequestContext.fromJson(
              Map<String, dynamic>.from(json['network_request_context']))
          : null,
      snapshotContext: json.containsKey('snapshot_context') &&
              json['snapshot_context'] != null
          ? SnapshotContext.fromJson(
              Map<String, dynamic>.from(json['snapshot_context']))
          : null,
      mobileVitalsContext: json.containsKey('mobile_vitals_context') &&
              json['mobile_vitals_context'] != null
          ? MobileVitalsContext.fromJson(
              Map<String, dynamic>.from(json['mobile_vitals_context']))
          : null,
      lifeCycleContext: json.containsKey('life_cycle_context') &&
              json['life_cycle_context'] != null
          ? LifeCycleContext.fromJson(
              Map<String, dynamic>.from(json['life_cycle_context']))
          : null,
      measurementContext: json.containsKey('measurement_context') &&
              json['measurement_context'] != null
          ? MeasurementContext.fromJson(
              Map<String, dynamic>.from(json['measurement_context']))
          : null,
      labels: json.containsKey('labels') && json['labels'] != null
          ? Map<String, dynamic>.from(json['labels'] as Map)
          : {},
      spanId: json['spanId'] as String,
      traceId: json['traceId'] as String,
      environment: json['environment'] as String,
      isSnapshotEvent: json['isSnapshotEvent'] as bool?,
      instrumentationData: json.containsKey('instrumentation_data') &&
              json['instrumentation_data'] != null
          ? InstrumentationData.fromJson(
              Map<String, dynamic>.from(json['instrumentation_data']))
          : null,
      fingerPrint: json['fingerPrint'] as String? ?? '',
      internalContext: json.containsKey('internal_context') &&
          json['internal_context'] != null
        ? InternalContext.fromJson(Map<String, dynamic>.from(json['internal_context']))
        : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'platform': platform,
      'mobile_sdk': mobileSdk?.toJson(),
      'version_metadata': versionMetadata?.toJson(),
      'session_context': sessionContext?.toJson(),
      'device_context': deviceContext?.toJson(),
      'device_state': deviceState?.toJson(),
      'view_context': viewContext?.toJson(),
      'event_context': eventContext?.toJson(),
      'error_context': errorContext?.toJson(),
      'interaction_context': interactionContext?.toJson(),
      'log_context': logContext?.toJson(),
      'network_request_context': networkRequestContext?.toJson(),
      'snapshot_context': snapshotContext?.toJson(),
      'mobile_vitals_context': mobileVitalsContext?.toJson(),
      'life_cycle_context': lifeCycleContext?.toJson(),
      'measurement_context': measurementContext?.toJson(),
      'labels': labels,
      'spanId': spanId,
      'traceId': traceId,
      'environment': environment,
      'isSnapshotEvent': isSnapshotEvent,
      'instrumentation_data': instrumentationData?.toJson(),
      'fingerPrint': fingerPrint,
      'internal_context': internalContext?.toJson(),
    };
  }
}

typedef BeforeSendResult = EditableCxRumEvent?;

abstract class InternalContext {
  final String event;
  const InternalContext(this.event);

  Map<String, dynamic> toJson();

  static InternalContext fromJson(Map<String, dynamic> json) {
    final event = json['event'];
    if (event is! String) {
      throw ArgumentError("Missing/invalid 'event' field");
    }

    switch (event) {
      case 'init':
        return InitInternalContext.fromJson(json);
      default:
        throw ArgumentError("Unknown event '$event'");
    }
  }
}

class InitInternalContext extends InternalContext {
  final InternalEventInitData data;

  const InitInternalContext({required this.data}) : super('init');

  factory InitInternalContext.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    if (dataJson is! Map) {
      throw ArgumentError("Missing/invalid 'data' for init event");
    }
    return InitInternalContext(
      data: InternalEventInitData.fromJson(Map<String, dynamic>.from(dataJson)),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'event': event,
    'data': data.toJson(),
  };
}

class InternalEventInitData {
  final String applicationName;
  final Map<String, dynamic>? labels;
  final String environment;
  final String version;

  final UserMetadata userContext;
  final ViewContext viewContext;

  final Map<String, bool> instrumentations;
  final Map<String, bool> mobileVitalsOptions;

  final List<String> ignoreUrls;
  final List<String> ignoreErrors;

  final bool collectIPData;
  final int sessionSampleRate;

  final Map<String, dynamic> traceParentInHeader;
  final bool debug;

  final String? proxyUrl;
  final String? beforeSend;

  const InternalEventInitData({
    required this.applicationName,
    required this.labels,
    required this.environment,
    required this.version,
    required this.userContext,
    required this.viewContext,
    required this.instrumentations,
    required this.mobileVitalsOptions,
    required this.ignoreUrls,
    required this.ignoreErrors,
    required this.collectIPData,
    required this.sessionSampleRate,
    required this.traceParentInHeader,
    required this.debug,
    this.proxyUrl,
    this.beforeSend,
  });

  factory InternalEventInitData.fromJson(Map<String, dynamic> json) {
    Map<String, bool> toBoolMap(Object? v) {
      if (v is! Map) return {};
      return v.map((k, val) => MapEntry(k.toString(), val == true));
    }

    List<String> toStringList(Object? v) {
      if (v is! List) return const [];
      return v.whereType<String>().toList();
    }

    Map<String, dynamic> toMap(Object? v) {
      if (v is! Map) return const {};
      return Map<String, dynamic>.from(v);
    }

    return InternalEventInitData(
      applicationName: (json['applicationName'] ?? '') as String,
      labels: toMap(json['labels']),
      environment: (json['environment'] ?? '') as String,
      version: (json['version'] ?? '') as String,
      userContext: json['userContext'] != null
          ? UserMetadata.fromJson(json['userContext'])
          : UserMetadata(userId: ''),
      viewContext: json['viewContext'] != null
          ? ViewContext.fromJson(json['viewContext'])
          : ViewContext(view: ''),
      instrumentations: toBoolMap(json['instrumentations']),
      mobileVitalsOptions: toBoolMap(json['mobileVitalsOptions']),
      ignoreUrls: toStringList(json['ignoreUrls']),
      ignoreErrors: toStringList(json['ignoreErrors']),
      collectIPData: json['collectIPData'] == true,
      sessionSampleRate: (json['sessionSampleRate'] is int)
          ? json['sessionSampleRate'] as int
          : int.tryParse('${json['sessionSampleRate']}') ?? 100,
      traceParentInHeader: toMap(json['traceParentInHeader']),
      debug: json['debug'] == true,
      proxyUrl: json['proxyUrl'] as String?,
      beforeSend: json['beforeSend'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'applicationName': applicationName,
    'labels': labels,
    'environment': environment,
    'version': version,
    'userContext': userContext.toJson(),
    'viewContext': viewContext.toJson(),
    'instrumentations': instrumentations,
    'mobileVitalsOptions': mobileVitalsOptions,
    'ignoreUrls': ignoreUrls,
    'ignoreErrors': ignoreErrors,
    'collectIPData': collectIPData,
    'sessionSampleRate': sessionSampleRate,
    'traceParentInHeader': traceParentInHeader,
    'debug': debug,
    'proxyUrl': proxyUrl,
    'beforeSend': beforeSend,
  };
}

