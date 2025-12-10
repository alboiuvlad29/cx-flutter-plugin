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

InteractionContext _$InteractionContextFromJson(Map<String, dynamic> json) =>
    InteractionContext(
      elementId: json['element_id'] as String?,
      eventName: json['event_name'] as String?,
      attributes: json['attributes'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$InteractionContextToJson(InteractionContext instance) =>
    <String, dynamic>{
      'element_id': instance.elementId,
      'event_name': instance.eventName,
      'attributes': instance.attributes,
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
      responseContentLength: (json['response_content_length'] as num?)?.toInt(),
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
      labels: json['labels'] as Map<String, dynamic>,
      spanId: json['spanId'] as String,
      traceId: json['traceId'] as String,
      environment: json['environment'] as String,
      isSnapshotEvent: json['isSnapshotEvent'] as bool?,
      instrumentationData: json['instrumentation_data'] == null
          ? null
          : InstrumentationData.fromJson(
              json['instrumentation_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CxRumEventToJson(CxRumEvent instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'mobile_sdk': instance.mobileSdk,
      'platform': instance.platform,
      'version_metadata': instance.versionMetadata,
      'session_context': instance.sessionContext,
      'device_context': instance.deviceContext,
      'device_state': instance.deviceState,
      'view_context': instance.viewContext,
      'event_context': instance.eventContext,
      'error_context': instance.errorContext,
      'interaction_context': instance.interactionContext,
      'log_context': instance.logContext,
      'network_request_context': instance.networkRequestContext,
      'snapshot_context': instance.snapshotContext,
      'mobile_vitals_context': instance.mobileVitalsContext,
      'life_cycle_context': instance.lifeCycleContext,
      'measurement_context': instance.measurementContext,
      'labels': instance.labels,
      'spanId': instance.spanId,
      'traceId': instance.traceId,
      'environment': instance.environment,
      'isSnapshotEvent': instance.isSnapshotEvent,
      'instrumentation_data': instance.instrumentationData,
    };

EditableCxRumEvent _$EditableCxRumEventFromJson(Map<String, dynamic> json) =>
    EditableCxRumEvent(
      platform: json['platform'] as String,
      versionMetadata: json['version_metadata'] == null
          ? null
          : VersionMetaData.fromJson(
              json['version_metadata'] as Map<String, dynamic>),
      timestamp: (json['timestamp'] as num).toInt(),
      mobileSdk: json['mobile_sdk'] == null
          ? null
          : MobileSdk.fromJson(json['mobile_sdk'] as Map<String, dynamic>),
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
      labels: json['labels'] as Map<String, dynamic>,
      spanId: json['spanId'] as String,
      traceId: json['traceId'] as String,
      environment: json['environment'] as String,
      isSnapshotEvent: json['isSnapshotEvent'] as bool?,
      instrumentationData: json['instrumentation_data'] == null
          ? null
          : InstrumentationData.fromJson(
              json['instrumentation_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EditableCxRumEventToJson(EditableCxRumEvent instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'mobile_sdk': instance.mobileSdk,
      'platform': instance.platform,
      'version_metadata': instance.versionMetadata,
      'session_context': instance.sessionContext,
      'device_context': instance.deviceContext,
      'device_state': instance.deviceState,
      'view_context': instance.viewContext,
      'event_context': instance.eventContext,
      'error_context': instance.errorContext,
      'interaction_context': instance.interactionContext,
      'log_context': instance.logContext,
      'network_request_context': instance.networkRequestContext,
      'snapshot_context': instance.snapshotContext,
      'mobile_vitals_context': instance.mobileVitalsContext,
      'life_cycle_context': instance.lifeCycleContext,
      'measurement_context': instance.measurementContext,
      'labels': instance.labels,
      'spanId': instance.spanId,
      'traceId': instance.traceId,
      'environment': instance.environment,
      'isSnapshotEvent': instance.isSnapshotEvent,
      'instrumentation_data': instance.instrumentationData,
    };
