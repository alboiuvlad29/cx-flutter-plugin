package com.coralogix.flutter.plugin.manager

import android.app.Application
import android.os.Handler
import android.os.Looper
import com.coralogix.android.sdk.CoralogixRum
import com.coralogix.android.sdk.session_replay.SessionReplay
import com.coralogix.android.sdk.session_replay.model.SessionReplayOptions
import com.coralogix.android.sdk.internal.features.instrumentations.network.NetworkRequestDetails
import com.coralogix.android.sdk.model.CoralogixOptions
import com.coralogix.android.sdk.model.Framework
import com.coralogix.android.sdk.model.TraceParentInHeaderConfig
import com.coralogix.android.sdk.model.TraceParentInHeaderConfigOptions

import com.coralogix.android.sdk.model.UserContext
import com.coralogix.android.sdk.session_replay.internal.MaskRegion
import com.coralogix.flutter.plugin.extensions.error
import com.coralogix.flutter.plugin.extensions.invalidArgumentsError
import com.coralogix.flutter.plugin.extensions.success
import com.coralogix.flutter.plugin.extensions.toStringAnyMap
import com.coralogix.flutter.plugin.extensions.toStringBooleanMap
import com.coralogix.flutter.plugin.extensions.toStringList
import com.coralogix.flutter.plugin.extensions.toStringMap
import com.coralogix.flutter.plugin.extensions.toUserContext
import com.coralogix.flutter.plugin.factories.ThrowableFactory
import com.coralogix.flutter.plugin.mappers.CoralogixDomainMapper
import com.coralogix.flutter.plugin.mappers.CoralogixLogSeverityMapper
import com.coralogix.flutter.plugin.mappers.InstrumentationMapper
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withContext

internal class FlutterPluginManager(
    private val application: Application,
    private val methodChannel: MethodChannel,
    override var eventSink: EventSink? = null
) : IFlutterPluginManager {
    override fun initialize(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments as? Map<*, *>
        if (arguments.isNullOrEmpty()) {
            result.invalidArgumentsError()
            return
        }

        val optionsDetails = arguments.toStringAnyMap()
        val labels = (optionsDetails["labels"] as? Map<*, *>)?.toStringMap()
        val ignoreUrls = (optionsDetails["ignoreUrls"] as? List<*>)?.toStringList()
        val ignoreErrors = (optionsDetails["ignoreErrors"] as? List<*>)?.toStringList()

        val userContextMap = (optionsDetails["userContext"] as? Map<*, *>)?.toStringMap()
        val userContext = userContextMap?.toUserContext() ?: UserContext()

        val instrumentationsMap = (optionsDetails["instrumentations"] as? Map<*, *>)?.toStringBooleanMap() ?: emptyMap()
        val instrumentations = InstrumentationMapper.toMap(instrumentationsMap)

        val domainString = optionsDetails["coralogixDomain"] as? String ?: ""
        val domain = try {
            CoralogixDomainMapper.toMap(domainString)
        } catch (e: IllegalArgumentException) {
            result.error("$domainString is not a supported Coralogix domain")
            return
        }

        val traceParentConfig = parseTraceParentInHeaderConfig(
            (optionsDetails["traceParentInHeader"] as? Map<*, *>)?.toStringAnyMap()
        )

        // Only set beforeSendCallback if Dart side has a beforeSend handler,
        // avoiding serialization and platform channel overhead for every event.
        val hasBeforeSend = optionsDetails["hasBeforeSend"] as? Boolean ?: false

        val options = CoralogixOptions(
            applicationName = optionsDetails["application"] as? String ?: "",
            coralogixDomain = domain,
            publicKey = optionsDetails["publicKey"] as? String ?: "",
            labels = labels ?: emptyMap(),
            environment = optionsDetails["environment"] as? String ?: "",
            version = optionsDetails["version"] as? String ?: "",
            userContext = userContext,
            instrumentations = instrumentations,
            ignoreUrls = ignoreUrls ?: emptyList(),
            ignoreErrors = ignoreErrors ?: emptyList(),
            collectIPData = optionsDetails["collectIPData"] as? Boolean ?: true,
            sessionSampleRate = optionsDetails["sdkSampler"] as? Int ?: 100,
            proxyUrl = optionsDetails["proxyUrl"] as? String,
            debug = optionsDetails["debug"] as? Boolean ?: false,
            traceParentInHeader = traceParentConfig,
            beforeSendCallback = if (hasBeforeSend) ::beforeSendHandler else null
        )

        val pluginVersion = optionsDetails["pluginVersion"] as? String ?: ""

        CoralogixRum.initialize(
            application,
            options,
            framework = Framework.HybridFramework.Flutter(pluginVersion)
        )

        result.success()
    }

    private fun parseTraceParentInHeaderConfig(
        map: Map<String, Any?>?
    ): TraceParentInHeaderConfig {
        if (map == null) return TraceParentInHeaderConfig()

        val enabled = map["enabled"] as? Boolean ?: false

        val optionsMap = map["options"] as? Map<*, *>

        val allowedTracingUrls = optionsMap
            ?.get("allowedTracingUrls")
            ?.let { value ->
                when (value) {
                    is List<*> -> value.filterIsInstance<String>()
                    else -> emptyList()
                }
            }
            ?: emptyList()

        return TraceParentInHeaderConfig(
            enabled = enabled,
            options = TraceParentInHeaderConfigOptions(
                allowedTracingUrls = allowedTracingUrls
            )
        )
    }

    private fun beforeSendHandler(data: List<Map<String, Any?>>) {
        Handler(Looper.getMainLooper()).post {
            eventSink?.success(data)
        }
    }

    override fun reportNetworkRequest(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments as? Map<*, *>
        if (arguments.isNullOrEmpty()) {
            result.invalidArgumentsError()
            return
        }

        val networkRequestDetailsMap = arguments.toStringAnyMap()
        val statusCode = networkRequestDetailsMap["status_code"] as? Int ?: 0

        val networkRequestDetails = NetworkRequestDetails(
            method = networkRequestDetailsMap["method"] as? String ?: "",
            statusCode = statusCode,
            url = networkRequestDetailsMap["url"] as? String ?: "",
            fragments = networkRequestDetailsMap["fragments"] as? String ?: "",
            host = networkRequestDetailsMap["host"] as? String ?: "",
            schema = networkRequestDetailsMap["schema"] as? String ?: "",
            duration = (networkRequestDetailsMap["duration"] as? Number)?.toLong() ?: 0L,
            responseContentLength = (networkRequestDetailsMap["http_response_body_size"] as? Number)?.toLong() ?: 0L
        )

        CoralogixRum.reportNetworkRequest(networkRequestDetails)
        result.success()
    }

    @Suppress("UNCHECKED_CAST")
    override fun setUserContext(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments as? Map<String, Any?>?
        if (arguments.isNullOrEmpty()) {
            result.invalidArgumentsError()
            return
        }

        CoralogixRum.setUserContext(arguments.toUserContext())
        result.success()
    }

    override fun setLabels(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments as? Map<*, *>
        if (arguments.isNullOrEmpty()) {
            result.invalidArgumentsError()
            return
        }

        CoralogixRum.setLabels(arguments.toStringMap())
        result.success()
    }

    override fun log(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments as? Map<*, *>
        if (arguments.isNullOrEmpty()) {
            result.invalidArgumentsError()
            return
        }

        val logDetails = arguments.toStringAnyMap()
        val message = logDetails["message"] as? String ?: ""
        val data = logDetails["data"] as? Map<String, Any?> ?: emptyMap()
        val severityLevel = logDetails["severity"] as? String ?: ""
        val severity = CoralogixLogSeverityMapper.toMap(severityLevel)
        CoralogixRum.log(severity, message, data)
        result.success()
    }

    override fun reportError(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments as? Map<*, *>
        if (arguments.isNullOrEmpty()) {
            result.invalidArgumentsError()
            return
        }

        val errorDetails = arguments.toStringMap()
        val message = errorDetails["message"] ?: ""
        val stackTrace = errorDetails["stackTrace"] ?: ""

        val throwable = ThrowableFactory.create(message, stackTrace)
        CoralogixRum.reportError(throwable)

        result.success()
    }

    override fun setView(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments as? Map<*, *>
        if (arguments.isNullOrEmpty()) {
            result.invalidArgumentsError()
            return
        }

        val viewDetails = arguments.toStringMap()
        val viewName = viewDetails["viewName"] ?: ""
        CoralogixRum.setViewContext(viewName)
        result.success()
    }

    override fun shutdown(result: MethodChannel.Result) {
        CoralogixRum.shutdown()
        result.success()
    }

    override fun getLabels(result: MethodChannel.Result) {
        val labels = CoralogixRum.getLabels()
        result.success(labels)
    }

    override fun isInitialized(result: MethodChannel.Result) {
        val isInitialized = CoralogixRum.isInitialized()
        result.success(isInitialized)
    }

    override fun getSessionId(result: MethodChannel.Result) {
        val sessionId = CoralogixRum.getSessionId()
        result.success(sessionId)
    }

    override fun setApplicationContext(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments as? Map<*, *>
        if (arguments.isNullOrEmpty()) {
            result.invalidArgumentsError()
            return
        }

        val applicationContextDetails = arguments.toStringMap()
        val applicationName = applicationContextDetails["applicationName"] ?: ""
        val applicationVersion = applicationContextDetails["applicationVersion"] ?: ""

        CoralogixRum.setApplicationContext(applicationName, applicationVersion)
        result.success()
    }

    @Suppress("UNCHECKED_CAST")
    override fun sendCxSpanData(call: MethodCall, result: MethodChannel.Result) {
        val data = call.arguments as? List<Map<String, Any?>>
        if (data.isNullOrEmpty()) {
            result.invalidArgumentsError()
            return
        }

        CoralogixRum.sendCxSpanData(data)
        result.success()
    }

    override fun recordFirstFrameTime(result: MethodChannel.Result) {
        result.success()
    }

    override fun sendCustomMeasurement(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments as? Map<*, *>
        if (arguments.isNullOrEmpty()) {
            result.invalidArgumentsError()
            return
        }

        val measurementDetails = arguments.toStringAnyMap()
        val name = measurementDetails["name"] as? String ?: ""
        val value = (measurementDetails["value"] as? Number)?.toLong() ?: 0L

        CoralogixRum.sendCustomMeasurement(name, value)
        result.success("sendCustomMeasurement success")
    }

    override fun initializeSessionReplay(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments as? Map<*, *>
        if (arguments.isNullOrEmpty()) {
            result.invalidArgumentsError()
            return
        }

        val args = arguments.toStringAnyMap()
        val captureScale = (args["captureScale"] as? Number)?.toDouble()?.toFloat() ?: 1.0f
        val captureCompressQuality = (args["captureCompressionQuality"] as? Number)?.toDouble()?.toFloat() ?: 1.0f
        val sessionRecordingSampleRate = (args["sessionRecordingSampleRate"] as? Number)?.toInt() ?: 100
        val autoStartSessionRecording = args["autoStartSessionRecording"] as? Boolean ?: true
        val maskAllTexts = args["maskAllTexts"] as? Boolean ?: false
        val textsToMaskRaw = args["textsToMask"] as? List<*>
        val textsToMask = textsToMaskRaw?.toStringList() ?: emptyList()
        val maskAllImages = args["maskAllImages"] as? Boolean ?: false

        val sessionReplayOptions = SessionReplayOptions(
            captureScale = captureScale,
            captureCompressQuality = captureCompressQuality,
            sessionRecordingSampleRate = sessionRecordingSampleRate,
            autoStartSessionRecording = autoStartSessionRecording,
            maskAllTexts = maskAllTexts,
            textsToMask = if (maskAllTexts) listOf(".*") else textsToMask,
            maskAllImages = maskAllImages,
            sampleFrameRatePerSecond = 1,
            flutterMaskRegionsProvider = { ids ->
                withContext(Dispatchers.Main) {
                    getMaskRegions(ids)
                }
            }
        )

        SessionReplay.initialize(application, sessionReplayOptions)
        result.success("initializeSessionReplay success")
    }

    override fun isSessionReplayInitialized(result: MethodChannel.Result) {
        result.success(SessionReplay.isInitialized())
    }

    override fun isRecording(result: MethodChannel.Result) {
        result.success(SessionReplay.isRecording())
    }

    override fun shutdownSessionReplay(result: MethodChannel.Result) {
        SessionReplay.shutdown()
        result.success("shutdownSessionReplay success")
    }

    override fun startSessionRecording(result: MethodChannel.Result) {
        SessionReplay.startSessionRecording()
        result.success("startSessionRecording success")
    }

    override fun stopSessionRecording(result: MethodChannel.Result) {
        SessionReplay.stopSessionRecording()
        result.success("stopSessionRecording success")
    }

    override fun captureScreenshot(result: MethodChannel.Result) {
        SessionReplay.captureScreenshot()
        result.success("captureScreenshot success")
    }

    override fun registerMaskRegion(call: MethodCall, result: MethodChannel.Result) {
        val regionId = call.arguments as? String
        if (regionId.isNullOrEmpty()) {
            result.invalidArgumentsError()
            return
        }

        SessionReplay.registerMaskedFlutterView(regionId)

        result.success("registerMaskRegion success")
    }

    override fun unregisterMaskRegion(call: MethodCall, result: MethodChannel.Result) {
        val regionId = call.arguments as? String
        if (regionId.isNullOrEmpty()) {
            result.invalidArgumentsError()
            return
        }

        SessionReplay.unregisterMaskedFlutterView(regionId)
        result.success("unregisterMaskRegion success")
    }

    @OptIn(ExperimentalCoroutinesApi::class)
    override suspend fun getMaskRegions(ids: List<String>): List<MaskRegion> = suspendCancellableCoroutine { cont ->
        methodChannel.invokeMethod("getMaskRegions", ids, object : MethodChannel.Result {
            override fun success(result: Any?) {
                val list = result as? List<*> ?: run {
                    cont.resume(emptyList(), onCancellation = null)
                    return
                }

                val regions = list.mapNotNull { item ->
                    val m = item as? Map<*, *> ?: return@mapNotNull null
                    val id = m["id"] as? String ?: return@mapNotNull null
                    val x = (m["x"] as? Number)?.toFloat() ?: return@mapNotNull null
                    val y = (m["y"] as? Number)?.toFloat() ?: return@mapNotNull null
                    val w = (m["width"] as? Number)?.toFloat() ?: return@mapNotNull null
                    val h = (m["height"] as? Number)?.toFloat() ?: return@mapNotNull null
                    val dpr = (m["dpr"] as? Number)?.toFloat() ?: 1.0f

                    MaskRegion(id, x, y, w, h, dpr)
                }

                cont.resume(regions, onCancellation = null)
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                cont.resume(emptyList(), onCancellation = null)
            }

            override fun notImplemented() {
                cont.resume(emptyList(), onCancellation = null)
            }
        })
    }
}