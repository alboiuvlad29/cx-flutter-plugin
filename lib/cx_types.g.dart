// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cx_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionMetaData _$VersionMetaDataFromJson(Map<String, dynamic> json) =>
    VersionMetaData(
      appName: json['app_name'] as String,
      appVersion: json['app_version'] as String,
    );

Map<String, dynamic> _$VersionMetaDataToJson(VersionMetaData instance) =>
    <String, dynamic>{
      'app_name': instance.appName,
      'app_version': instance.appVersion,
    };

MobileSdk _$MobileSdkFromJson(Map<String, dynamic> json) => MobileSdk(
      sdkVersion: json['sdk_version'] as String,
      framework: json['framework'] as String,
      operatingSystem: json['os'] as String,
    );

Map<String, dynamic> _$MobileSdkToJson(MobileSdk instance) => <String, dynamic>{
      'sdk_version': instance.sdkVersion,
      'framework': instance.framework,
      'os': instance.operatingSystem,
    };

UserMetadata _$UserMetadataFromJson(Map<String, dynamic> json) => UserMetadata(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String?,
      userEmail: json['user_email'] as String?,
      userMetadata: json['user_metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserMetadataToJson(UserMetadata instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'user_email': instance.userEmail,
      'user_metadata': instance.userMetadata,
    };

SessionContext _$SessionContextFromJson(Map<String, dynamic> json) =>
    SessionContext(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String?,
      userEmail: json['user_email'] as String?,
      userMetadata: json['user_metadata'] as Map<String, dynamic>?,
      device: json['device'] as String?,
      os: json['os'] as String?,
      osVersion: json['osVersion'],
      sessionId: json['session_id'] as String?,
      sessionCreationDate: json['session_creation_date'] as num?,
    );

Map<String, dynamic> _$SessionContextToJson(SessionContext instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'user_email': instance.userEmail,
      'user_metadata': instance.userMetadata,
      'device': instance.device,
      'os': instance.os,
      'osVersion': instance.osVersion,
      'session_id': instance.sessionId,
      'session_creation_date': instance.sessionCreationDate,
    };

DeviceState _$DeviceStateFromJson(Map<String, dynamic> json) => DeviceState(
      battery: json['battery'] as String?,
      networkType: json['network_type'] as String?,
    );

Map<String, dynamic> _$DeviceStateToJson(DeviceState instance) =>
    <String, dynamic>{
      'battery': instance.battery,
      'network_type': instance.networkType,
    };

DeviceContext _$DeviceContextFromJson(Map<String, dynamic> json) =>
    DeviceContext(
      device: json['device'] as String?,
      deviceName: json['device_name'] as String?,
      emulator: json['emulator'] as bool?,
      os: json['os'] as String?,
      osVersion: json['osVersion'],
    );

Map<String, dynamic> _$DeviceContextToJson(DeviceContext instance) =>
    <String, dynamic>{
      'device': instance.device,
      'device_name': instance.deviceName,
      'emulator': instance.emulator,
      'os': instance.os,
      'osVersion': instance.osVersion,
    };

EventContext _$EventContextFromJson(Map<String, dynamic> json) => EventContext(
      type: $enumDecode(_$CoralogixEventTypeEnumMap, json['type']),
      severity: $enumDecodeNullable(_$CxLogSeverityEnumMap, json['severity']),
    );

Map<String, dynamic> _$EventContextToJson(EventContext instance) =>
    <String, dynamic>{
      'type': _$CoralogixEventTypeEnumMap[instance.type]!,
      'severity': _$CxLogSeverityEnumMap[instance.severity],
    };

const _$CoralogixEventTypeEnumMap = {
  CoralogixEventType.error: 'error',
  CoralogixEventType.networkRequest: 'network-request',
  CoralogixEventType.log: 'log',
  CoralogixEventType.userInteraction: 'user-interaction',
  CoralogixEventType.webVitals: 'webVitals',
  CoralogixEventType.longTask: 'longTask',
  CoralogixEventType.resources: 'resources',
  CoralogixEventType.internal: 'internal',
  CoralogixEventType.navigation: 'navigation',
  CoralogixEventType.mobileVitals: 'mobile-vitals',
  CoralogixEventType.lifeCycle: 'life-cycle',
  CoralogixEventType.customMeasurement: 'custom-measurement',
};

const _$CxLogSeverityEnumMap = {
  CxLogSeverity.debug: 1,
  CxLogSeverity.verbose: 2,
  CxLogSeverity.info: 3,
  CxLogSeverity.warn: 4,
  CxLogSeverity.error: 5,
  CxLogSeverity.critical: 6,
};

ErrorContext _$ErrorContextFromJson(Map<String, dynamic> json) => ErrorContext(
      domain: json['domain'] as String?,
      code: json['code'] as String?,
      errorMessage: json['error_message'] as String?,
      userInfo: json['user_info'] as String?,
      originalStacktrace: (json['original_stacktrace'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      errorType: json['error_type'] as String?,
      isCrashed: json['is_crashed'] as bool?,
      eventType: json['event_type'] as String?,
      errorContext: json['error_context'] as String?,
      crashTimestamp: json['crash_timestamp'] as String?,
      processName: json['process_name'] as String?,
      applicationIdentifier: json['application_identifier'] as String?,
      triggeredByThread: json['triggered_by_thread'] as String?,
      baseAddress: json['base_address'] as String?,
      arch: json['arch'] as String?,
      threads: (json['threads'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$ErrorContextToJson(ErrorContext instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'code': instance.code,
      'error_message': instance.errorMessage,
      'user_info': instance.userInfo,
      'original_stacktrace': instance.originalStacktrace,
      'error_type': instance.errorType,
      'is_crashed': instance.isCrashed,
      'event_type': instance.eventType,
      'error_context': instance.errorContext,
      'crash_timestamp': instance.crashTimestamp,
      'process_name': instance.processName,
      'application_identifier': instance.applicationIdentifier,
      'triggered_by_thread': instance.triggeredByThread,
      'base_address': instance.baseAddress,
      'arch': instance.arch,
      'threads': instance.threads,
    };

LogContext _$LogContextFromJson(Map<String, dynamic> json) => LogContext(
      message: json['message'] as String,
      data: json['data'],
    );

Map<String, dynamic> _$LogContextToJson(LogContext instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

MeasurementContext _$MeasurementContextFromJson(Map<String, dynamic> json) =>
    MeasurementContext(
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$MeasurementContextToJson(MeasurementContext instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };

NetworkRequestContext _$NetworkRequestContextFromJson(
        Map<String, dynamic> json) =>
    NetworkRequestContext(
      method: json['method'] as String,
      statusCode: (json['status_code'] as num).toInt(),
      url: json['url'] as String,
      fragments: json['fragments'] as String?,
      host: json['host'] as String?,
      schema: json['schema'] as String?,
      statusText: json['status_text'] as String?,
      responseContentLength: json['response_content_length'] as String?,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$NetworkRequestContextToJson(
        NetworkRequestContext instance) =>
    <String, dynamic>{
      'method': instance.method,
      'status_code': instance.statusCode,
      'url': instance.url,
      'fragments': instance.fragments,
      'host': instance.host,
      'schema': instance.schema,
      'status_text': instance.statusText,
      'response_content_length': instance.responseContentLength,
      'duration': instance.duration,
    };

SnapshotContext _$SnapshotContextFromJson(Map<String, dynamic> json) =>
    SnapshotContext(
      timestamp: (json['timestamp'] as num).toInt(),
      errorCount: (json['errorCount'] as num).toInt(),
      viewCount: (json['viewCount'] as num).toInt(),
      actionCount: (json['clickCount'] as num).toInt(),
      hasRecording: json['hasRecording'] as bool,
    );

Map<String, dynamic> _$SnapshotContextToJson(SnapshotContext instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'errorCount': instance.errorCount,
      'viewCount': instance.viewCount,
      'clickCount': instance.actionCount,
      'hasRecording': instance.hasRecording,
    };

LifeCycleContext _$LifeCycleContextFromJson(Map<String, dynamic> json) =>
    LifeCycleContext(
      eventName: json['event_name'] as String?,
    );

Map<String, dynamic> _$LifeCycleContextToJson(LifeCycleContext instance) =>
    <String, dynamic>{
      'event_name': instance.eventName,
    };

MobileVitalsContext _$MobileVitalsContextFromJson(Map<String, dynamic> json) =>
    MobileVitalsContext(
      type: json['type'] as String,
      value: json['value'],
    );

Map<String, dynamic> _$MobileVitalsContextToJson(
        MobileVitalsContext instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
    };

ViewContext _$ViewContextFromJson(Map<String, dynamic> json) => ViewContext(
      view: json['view'] as String?,
    );

Map<String, dynamic> _$ViewContextToJson(ViewContext instance) =>
    <String, dynamic>{
      'view': instance.view,
    };

InstrumentationData _$InstrumentationDataFromJson(Map<String, dynamic> json) =>
    InstrumentationData(
      otelResource:
          OtelResource.fromJson(json['otelResource'] as Map<String, dynamic>),
      otelSpan: OtelSpan.fromJson(json['otelSpan'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InstrumentationDataToJson(
        InstrumentationData instance) =>
    <String, dynamic>{
      'otelResource': instance.otelResource,
      'otelSpan': instance.otelSpan,
    };

OtelResource _$OtelResourceFromJson(Map<String, dynamic> json) => OtelResource(
      attributes: json['attributes'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$OtelResourceToJson(OtelResource instance) =>
    <String, dynamic>{
      'attributes': instance.attributes,
    };

OtelSpan _$OtelSpanFromJson(Map<String, dynamic> json) => OtelSpan(
      status: SpanStatus.fromJson(json['status'] as Map<String, dynamic>),
      spanId: json['spanId'] as String,
      endTime: OtelSpan._bigIntListFromJson(json['endTime'] as List),
      traceId: json['traceId'] as String,
      duration:
          (json['duration'] as List<dynamic>).map((e) => e as String).toList(),
      attributes: json['attributes'] as Map<String, dynamic>,
      kind: (json['kind'] as num).toInt(),
      name: json['name'] as String,
      startTime: OtelSpan._bigIntListFromJson(json['startTime'] as List),
    );

Map<String, dynamic> _$OtelSpanToJson(OtelSpan instance) => <String, dynamic>{
      'status': instance.status,
      'spanId': instance.spanId,
      'endTime': OtelSpan._bigIntListToJson(instance.endTime),
      'traceId': instance.traceId,
      'duration': instance.duration,
      'attributes': instance.attributes,
      'kind': instance.kind,
      'name': instance.name,
      'startTime': OtelSpan._bigIntListToJson(instance.startTime),
    };

SpanStatus _$SpanStatusFromJson(Map<String, dynamic> json) => SpanStatus(
      code: (json['code'] as num).toInt(),
    );

Map<String, dynamic> _$SpanStatusToJson(SpanStatus instance) =>
    <String, dynamic>{
      'code': instance.code,
    };

CxRumEvent _$CxRumEventFromJson(Map<String, dynamic> json) => CxRumEvent(
      timestamp: (json['timestamp'] as num).toInt(),
      mobileSdk: json['mobileSdk'] == null
          ? null
          : MobileSdk.fromJson(json['mobileSdk'] as Map<String, dynamic>),
      platform: json['platform'] as String,
      versionMetadata: json['versionMetadata'] == null
          ? null
          : VersionMetaData.fromJson(
              json['versionMetadata'] as Map<String, dynamic>),
      sessionContext: json['sessionContext'] == null
          ? null
          : SessionContext.fromJson(
              json['sessionContext'] as Map<String, dynamic>),
      deviceContext: json['deviceContext'] == null
          ? null
          : DeviceContext.fromJson(
              json['deviceContext'] as Map<String, dynamic>),
      deviceState: json['deviceState'] == null
          ? null
          : DeviceState.fromJson(json['deviceState'] as Map<String, dynamic>),
      viewContext: json['viewContext'] == null
          ? null
          : ViewContext.fromJson(json['viewContext'] as Map<String, dynamic>),
      eventContext: json['eventContext'] == null
          ? null
          : EventContext.fromJson(json['eventContext'] as Map<String, dynamic>),
      errorContext: json['errorContext'] == null
          ? null
          : ErrorContext.fromJson(json['errorContext'] as Map<String, dynamic>),
      interactionContext: json['interaction_context'] == null
          ? null
          : InteractionContext.fromJson(
              json['interaction_context'] as Map<String, dynamic>),
      logContext: json['logContext'] == null
          ? null
          : LogContext.fromJson(json['logContext'] as Map<String, dynamic>),
      networkRequestContext: json['networkRequestContext'] == null
          ? null
          : NetworkRequestContext.fromJson(
              json['networkRequestContext'] as Map<String, dynamic>),
      snapshotContext: json['snapshotContext'] == null
          ? null
          : SnapshotContext.fromJson(
              json['snapshotContext'] as Map<String, dynamic>),
      mobileVitalsContext: json['mobileVitalsContext'] == null
          ? null
          : MobileVitalsContext.fromJson(
              json['mobileVitalsContext'] as Map<String, dynamic>),
      lifeCycleContext: json['lifeCycleContext'] == null
          ? null
          : LifeCycleContext.fromJson(
              json['lifeCycleContext'] as Map<String, dynamic>),
      measurementContext: json['measurement_context'] == null
          ? null
          : MeasurementContext.fromJson(
              json['measurement_context'] as Map<String, dynamic>),
      labels: json['labels'] as Map<String, dynamic>,
      spanId: json['spanId'] as String,
      traceId: json['traceId'] as String,
      environment: json['environment'] as String,
      isSnapshotEvent: json['isSnapshotEvent'] as bool?,
      instrumentationData: json['instrumentationData'] == null
          ? null
          : InstrumentationData.fromJson(
              json['instrumentationData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CxRumEventToJson(CxRumEvent instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'mobileSdk': instance.mobileSdk,
      'platform': instance.platform,
      'versionMetadata': instance.versionMetadata,
      'sessionContext': instance.sessionContext,
      'deviceContext': instance.deviceContext,
      'deviceState': instance.deviceState,
      'viewContext': instance.viewContext,
      'eventContext': instance.eventContext,
      'errorContext': instance.errorContext,
      'interaction_context': instance.interactionContext,
      'logContext': instance.logContext,
      'networkRequestContext': instance.networkRequestContext,
      'snapshotContext': instance.snapshotContext,
      'mobileVitalsContext': instance.mobileVitalsContext,
      'lifeCycleContext': instance.lifeCycleContext,
      'measurement_context': instance.measurementContext,
      'labels': instance.labels,
      'spanId': instance.spanId,
      'traceId': instance.traceId,
      'environment': instance.environment,
      'isSnapshotEvent': instance.isSnapshotEvent,
      'instrumentationData': instance.instrumentationData,
    };

EditableCxRumEvent _$EditableCxRumEventFromJson(Map<String, dynamic> json) =>
    EditableCxRumEvent(
      platform: json['platform'] as String,
      versionMetadata: json['versionMetadata'] == null
          ? null
          : VersionMetaData.fromJson(
              json['versionMetadata'] as Map<String, dynamic>),
      timestamp: (json['timestamp'] as num).toInt(),
      mobileSdk: json['mobileSdk'] == null
          ? null
          : MobileSdk.fromJson(json['mobileSdk'] as Map<String, dynamic>),
      sessionContext: json['sessionContext'] == null
          ? null
          : SessionContext.fromJson(
              json['sessionContext'] as Map<String, dynamic>),
      deviceContext: json['deviceContext'] == null
          ? null
          : DeviceContext.fromJson(
              json['deviceContext'] as Map<String, dynamic>),
      deviceState: json['deviceState'] == null
          ? null
          : DeviceState.fromJson(json['deviceState'] as Map<String, dynamic>),
      viewContext: json['viewContext'] == null
          ? null
          : ViewContext.fromJson(json['viewContext'] as Map<String, dynamic>),
      eventContext: json['eventContext'] == null
          ? null
          : EventContext.fromJson(json['eventContext'] as Map<String, dynamic>),
      errorContext: json['errorContext'] == null
          ? null
          : ErrorContext.fromJson(json['errorContext'] as Map<String, dynamic>),
      interactionContext: json['interaction_context'] == null
          ? null
          : InteractionContext.fromJson(
              json['interaction_context'] as Map<String, dynamic>),
      logContext: json['logContext'] == null
          ? null
          : LogContext.fromJson(json['logContext'] as Map<String, dynamic>),
      networkRequestContext: json['networkRequestContext'] == null
          ? null
          : NetworkRequestContext.fromJson(
              json['networkRequestContext'] as Map<String, dynamic>),
      snapshotContext: json['snapshotContext'] == null
          ? null
          : SnapshotContext.fromJson(
              json['snapshotContext'] as Map<String, dynamic>),
      mobileVitalsContext: json['mobileVitalsContext'] == null
          ? null
          : MobileVitalsContext.fromJson(
              json['mobileVitalsContext'] as Map<String, dynamic>),
      lifeCycleContext: json['lifeCycleContext'] == null
          ? null
          : LifeCycleContext.fromJson(
              json['lifeCycleContext'] as Map<String, dynamic>),
      measurementContext: json['measurement_context'] == null
          ? null
          : MeasurementContext.fromJson(
              json['measurement_context'] as Map<String, dynamic>),
      labels: json['labels'] as Map<String, dynamic>,
      spanId: json['spanId'] as String,
      traceId: json['traceId'] as String,
      environment: json['environment'] as String,
      isSnapshotEvent: json['isSnapshotEvent'] as bool?,
      instrumentationData: json['instrumentationData'] == null
          ? null
          : InstrumentationData.fromJson(
              json['instrumentationData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EditableCxRumEventToJson(EditableCxRumEvent instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'mobileSdk': instance.mobileSdk,
      'platform': instance.platform,
      'versionMetadata': instance.versionMetadata,
      'sessionContext': instance.sessionContext,
      'deviceContext': instance.deviceContext,
      'deviceState': instance.deviceState,
      'viewContext': instance.viewContext,
      'eventContext': instance.eventContext,
      'errorContext': instance.errorContext,
      'interaction_context': instance.interactionContext,
      'logContext': instance.logContext,
      'networkRequestContext': instance.networkRequestContext,
      'snapshotContext': instance.snapshotContext,
      'mobileVitalsContext': instance.mobileVitalsContext,
      'lifeCycleContext': instance.lifeCycleContext,
      'measurement_context': instance.measurementContext,
      'labels': instance.labels,
      'spanId': instance.spanId,
      'traceId': instance.traceId,
      'environment': instance.environment,
      'isSnapshotEvent': instance.isSnapshotEvent,
      'instrumentationData': instance.instrumentationData,
    };
