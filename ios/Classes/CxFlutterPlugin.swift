import Coralogix
import CoralogixInternal
import SessionReplay
import Flutter
import UIKit

enum CxSdkError: Error {
    case invalidPublicKey
    case missingParameter
}

public class CxFlutterPlugin: NSObject, FlutterPlugin {
    var coralogixRum: CoralogixRum?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    private var methodChannel: FlutterMethodChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "cx_flutter_plugin", binaryMessenger: registrar.messenger())
        let instance = CxFlutterPlugin()
        instance.methodChannel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)

        // Initialize event channel
        instance.eventChannel = FlutterEventChannel(
            name: "cx_flutter_plugin/onBeforeSend",
            binaryMessenger: registrar.messenger())
        instance.eventChannel?.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initSdk":
            self.initSdk(call: call, result: result)
        case "setNetworkRequestContext":
            self.setNetworkRequestContext(call: call, result: result)
        case "setUserContext":
            self.setUserContext(call: call, result: result)
        case "setLabels":
            self.setLabels(call: call, result: result)
        case "shutdown":
            self.shutdown(call: call, result: result)
        case "log":
            self.log(call: call, result: result)
        case "reportError":
            self.reportError(call: call, result: result)
        case "setView":
            self.setView(call: call, result: result)
        case "sendCxSpanData":
            self.sendCxSpanData(call: call, result: result)
        case "getLabels":
            self.getLabels(call: call, result: result)
        case "isInitialized":
            self.isInitialized(call: call, result: result)
        case "getSessionId":
            self.getSessionId(call: call, result: result)
        case "setApplicationContext":
            self.setApplicationContext(call: call, result: result)
        case "sendCustomMeasurement":
            self.sendCustomMeasurement(call: call, result: result)
        case "initializeSessionReplay":
            self.initializeSessionReplay(call: call, result: result)
         case "isSessionReplayInitialized":
             self.isSessionReplayInitialized(call: call, result: result)
         case "isRecording":
             self.isRecording(call: call, result: result)
         case "shutdownSessionReplay":
             self.shutdownSessionReplay(call: call, result: result)
         case "startSessionRecording":
             self.startSessionRecording(call: call, result: result)
         case "stopSessionRecording":
             self.stopSessionRecording(call: call, result: result)
         case "captureScreenshot":
             self.captureScreenshot(call: call, result: result)
         case "registerMaskRegion":
             self.registerMaskRegion(call: call, result: result)
         case "unregisterMaskRegion":
             self.unregisterMaskRegion(call: call, result: result)
        case "getSessionReplayFolderPath":
             self.getSessionReplayFolderPath(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func getSessionId(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let sessionId = self.coralogixRum?.getSessionId
        result(sessionId)
    }

    private func setApplicationContext(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any], !arguments.isEmpty else {
            result(FlutterError(code: "4", message: "Arguments is null or empty", details: nil))
            return
        }
        let applicationContext = arguments["applicationName"] as? String ?? ""
        let applicationVersion = arguments["applicationVersion"] as? String ?? ""
        self.coralogixRum?.setApplicationContext(application: applicationContext, version: applicationVersion)
        result("setApplicationContext success")
    }

    private func isInitialized(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let isInitialized = self.coralogixRum?.isInitialized ?? false
        result(isInitialized)
    }

    private func sendCxSpanData(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let beforeSendResults = call.arguments as? [[String: Any]], !beforeSendResults.isEmpty else {
            result(FlutterError(code: "4", message: "Arguments is null or empty", details: nil))
            return
        }
        self.coralogixRum?.sendBeforeSendData(beforeSendResults)
        result("sendCxSpanData success")
    }

    private func initSdk(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let parameters = call.arguments as? [String: Any], !parameters.isEmpty else {
            result(FlutterError(code: "4", message: "parameters is null or empty", details: nil))
            return
        }

        do {
            // Only create beforeSendCallback if Dart side has a beforeSend handler,
            // avoiding serialization and platform channel overhead for every event.
            let hasBeforeSend = parameters["hasBeforeSend"] as? Bool ?? false
            let beforeSendCallBack: (([[String: Any]]) -> Void)? = hasBeforeSend ?
                { [weak self] (event: [[String: Any]]) -> Void in
                    print("event: \(event)")
                    let safePayload = self?.makeJSONSafe(event)
                    DispatchQueue.main.async {
                        self?.eventSink?(safePayload)
                    }
                  } : nil

            var options = try self.toCoralogixOptions(parameter: parameters)
            options.beforeSendCallBack = beforeSendCallBack
            let version = parameters["pluginVersion"] as? String ?? ""
            self.coralogixRum = CoralogixRum(options: options, sdkFramework: .flutter(version: version))
            result("initialize success")
            return
        } catch let error as CxSdkError {
            result(
                FlutterError(
                    code: "CX_SDK_ERROR", message: error.localizedDescription, details: error))
            return
        } catch {
            result(
                FlutterError(
                    code: "UNEXPECTED_ERROR",
                    message: "An unexpected error occurred: \(error.localizedDescription)",
                    details: error))
            return
        }
    }

    private func setNetworkRequestContext(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any], !arguments.isEmpty else {
            result(FlutterError(code: "4", message: "Arguments is null or empty", details: nil))
            return
        }
        self.coralogixRum?.setNetworkRequestContext(dictionary: arguments)
        result("setNetworkRequestContext success")
    }

    private func setUserContext(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any], !arguments.isEmpty else {
            result(FlutterError(code: "4", message: "Arguments is null or empty", details: nil))
            return
        }

        let userContext = UserContext(
            userId: arguments["user_id"] as? String ?? "",
            userName: arguments["user_name"] as? String ?? "",
            userEmail: arguments["user_email"] as? String ?? "",
            userMetadata: arguments["user_metadata"] as? [String: String] ?? [String: String]())

        self.coralogixRum?.setUserContext(userContext: userContext)
        result("setUserContext success")
    }

    private func setLabels(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any], !arguments.isEmpty else {
            result(FlutterError(code: "4", message: "Arguments is null or empty", details: nil))
            return
        }
        self.coralogixRum?.set(labels: arguments)
        result("setLabels success")
    }

    private func log(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any], !arguments.isEmpty,
            let severity = arguments["severity"] as? String,
            let cxLogSeverity = self.getCoralogixLogSeverity(rawValue: severity)
        else {
            result(FlutterError(code: "4", message: "Arguments is null or empty", details: nil))
            return
        }
        let data = arguments["data"] as? [String: Any] ?? [String: Any]()
        let message = arguments["message"] as? String ?? ""

        self.coralogixRum?.log(severity: cxLogSeverity, message: message, data: data)
        result("log success")
    }

    private func reportError(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any], !arguments.isEmpty else {
            result(FlutterError(code: "4", message: "Arguments is null or empty", details: nil))
            return
        }

        let message = {
            if let msg = arguments["message"] as? String, !msg.isEmpty {
                return msg
            }
            return "Unknown error"
        }()


        if let stackTrace = arguments["stackTrace"] as? String, !stackTrace.isEmpty {
            let stackTraceArray: [[String: Any]] = stackTrace
            .components(separatedBy: .newlines)
            .flatMap { return CxFlutterPlugin.parseStackTrace($0) }

            self.coralogixRum?.reportError(
                message: message,
                 stackTrace: stackTraceArray,
                  errorType: nil
            )

            result("reportError with stackTrace success")
            return
        }

        if let data = arguments["data"] as? [String: Any] {
            self.coralogixRum?.reportError(message: message, data: data)
            result("reportError with data success")
            return
        }

        result(FlutterError(code: "5",
                        message: "Neither stackTrace nor data was provided",
                        details: nil))
    }
    
    private func setView(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any], !arguments.isEmpty else {
            result(FlutterError(code: "4", message: "Arguments is null or empty", details: nil))
            return
        }

        let viewName = arguments["viewName"] as? String ?? ""
        self.coralogixRum?.setView(name: viewName)
        result("setView success")
    }

    private func shutdown(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.coralogixRum?.shutdown()
        result("shutdown success")
    }

    private func getLabels(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let lables = self.coralogixRum?.labels
        result(lables)
    }

    private func sendCustomMeasurement(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any], !arguments.isEmpty else {
            result(FlutterError(code: "4", message: "Arguments is null or empty", details: nil))
            return
        }
        let name = arguments["name"] as? String ?? ""
        let value = arguments["value"] as? Double ?? 0.0
    
        guard let rum = self.coralogixRum else {
            result(FlutterError(code: "NOT_INITIALIZED", message: "SDK is not initialized", details: nil))
            return
        }

        rum.sendCustomMeasurement(name: name, value: value)
        result("sendCustomMeasurement success")
    }

    private func getCoralogixLogSeverity(rawValue: String) -> CoralogixLogSeverity? {
        switch rawValue.lowercased() {
        case "debug": return CoralogixLogSeverity.debug
        case "verbose": return CoralogixLogSeverity.verbose
        case "info": return CoralogixLogSeverity.info
        case "warn": return CoralogixLogSeverity.warn
        case "error": return CoralogixLogSeverity.error
        case "critical": return CoralogixLogSeverity.critical
        default: return nil
        }
    }

    private func instrumentationType(from string: String) -> CoralogixExporterOptions
        .InstrumentationType?
    {
        switch string {
        case "mobileVitals":
            return .mobileVitals
        case "custom":
            return .custom
        case "errors":
            return .errors
        case "network":
            return .network
        case "userActions":
            return .userActions
        case "anr":
            return .anr
        case "lifeCycle":
            return .lifeCycle
        default:
            return nil
        }
    }

    private func toSessionReplayOptions(parameter: [String: Any]) throws -> SessionReplayOptions {
        let captureScale = parameter["captureScale"] as? Double ?? 2.0
        let captureCompressionQuality = parameter["captureCompressionQuality"] as? Double ?? 0.8
        let sessionRecordingSampleRate = parameter["sessionRecordingSampleRate"] as? Int ?? 100
        let maskAllTexts = parameter["maskAllTexts"] as? Bool ?? false
        let textsToMask = parameter["textsToMask"] as? [String] ?? []
        let maskAllImages = parameter["maskAllImages"] as? Bool ?? false
        let autoStartSessionRecording = parameter["autoStartSessionRecording"] as? Bool ?? true
        let sessionReplayOptions = SessionReplayOptions(recordingType: .image,
                                                        captureScale: captureScale,
                                                        captureCompressionQuality: captureCompressionQuality,
                                                        sessionRecordingSampleRate: Int(sessionRecordingSampleRate),
                                                        maskText: maskAllTexts ? [".*"] : textsToMask,
                                                        maskOnlyCreditCards: false,
                                                        maskAllImages: maskAllImages,
                                                        autoStartSessionRecording: autoStartSessionRecording,
                                                        maskRegionsProvider: { [weak self] ids, completion in
                                                            self?.getMaskRegions(ids: ids, completion: completion)
                                                        })
        return sessionReplayOptions
    }
    
    private func getMaskRegions(ids: [String], completion: @escaping ([MaskRegion]) -> Void) {
        guard let channel = self.methodChannel else {
            completion([])
            return
        }
        
        DispatchQueue.main.async {
            channel.invokeMethod("getMaskRegions", arguments: ids) { result in
                guard let list = result as? [[String: Any]] else {
                    completion([])
                    return
                }
                
                let regions = list.compactMap { item -> MaskRegion? in
                    guard let id = item["id"] as? String,
                          let x = item["x"] as? Double,
                          let y = item["y"] as? Double,
                          let width = item["width"] as? Double,
                          let height = item["height"] as? Double else {
                        return nil
                    }
                    let dpr = item["dpr"] as? Double ?? 1.0
                    return MaskRegion(id: id, x: x, y: y, width: width, height: height, dpr: dpr)
                }
                
                completion(regions)
            }
        }
    }

    private func toCoralogixOptions(parameter: [String: Any]) throws -> CoralogixExporterOptions {
        let userContextDict = parameter["userContext"] as? [String: Any] ?? [String: Any]()
        let userContext = UserContext(
            userId: userContextDict["user_id"] as? String ?? "",
            userName: userContextDict["user_name"] as? String ?? "",
            userEmail: userContextDict["user_email"] as? String ?? "",
            userMetadata: userContextDict["user_metadata"] as? [String: String] ?? [String: String]()
        )

        let lablesDict = parameter["labels"] as? [String: Any] ?? [String: Any]()
        let instrumentations = parameter["instrumentations"] as? [String: Bool] ?? [String: Bool]()
        var instrumentationDict: [CoralogixExporterOptions.InstrumentationType: Bool] = [:]

        for (key, value) in instrumentations {
            if let instrumentationKey = instrumentationType(from: key) {
                instrumentationDict[instrumentationKey] = value
            }
        }

        guard let domain = parameter["coralogixDomain"] as? String,
            let coralogixDomain = CoralogixDomain(rawValue: domain)
        else {
            throw CxSdkError.invalidPublicKey
        }

        let options = CoralogixExporterOptions(
            coralogixDomain: coralogixDomain,
            userContext: userContext,
            environment: parameter["environment"] as? String ?? "",
            application: parameter["application"] as? String ?? "",
            version: parameter["version"] as? String ?? "",
            publicKey: parameter["publicKey"] as? String ?? "",
            ignoreUrls: parameter["ignoreUrls"] as? [String] ?? [String](),
            ignoreErrors: parameter["ignoreErrors"] as? [String] ?? [String](),
            labels: lablesDict,
            sessionSampleRate: parameter["sdkSampler"] as? Int ?? 100,
            fpsSampleRate: parameter["mobileVitalsFPSSamplingRate"] as? Double ?? 300.0,
            instrumentations: instrumentationDict,
            collectIPData: parameter["collectIPData"] as? Bool ?? true,
            enableSwizzling: parameter["enableSwizzling"] as? Bool ?? true,
            proxyUrl: parameter["proxyUrl"] as? String ?? nil,
            traceParentInHeader: parameter["traceParentInHeader"] as? [String: Any] ?? nil,
            debug: parameter["debug"] as? Bool ?? false)
        return options
    }
    
    func makeJSONSafe(_ input: Any) -> Any {
        if let dict = input as? [String: Any] {
            return dict.mapValues { makeJSONSafe($0) }
        } else if let array = input as? [Any] {
            return array.map { makeJSONSafe($0) }
        } else if input is String || input is Int || input is Double || input is Bool || input is UInt64 || input is NSNull {
            return input
        } else {
            return "\(input)" // fallback: convert to string
        }
    }

    private static func parseStackTrace(_ stackTrace: String) -> [[String: Any]] {
        var result: [[String: Any]] = []
        
        // Split the stack trace into lines
        let lines = stackTrace.split(separator: "\n")
        
        // Regular expression to match the stack trace pattern
        guard let regex = try? NSRegularExpression(pattern: "^#(\\d+)\\s+([^\\(]+)\\s+\\((.*):(\\d+):(\\d+)\\)$") else {
            return [[String: Any]]()
        }
        
        for line in lines {
            let lineStr = String(line)
            let range = NSRange(location: 0, length: lineStr.utf16.count)
            
            if let match = regex.firstMatch(in: lineStr, options: [], range: range) {
                var dict: [String: Any] = [:]
                
//                if let range = Range(match.range(at: 1), in: lineStr) {
//                    dict["index"] = Int(lineStr[range])
//                }
                if let range = Range(match.range(at: 2), in: lineStr) {
                    dict["functionName"] = String(lineStr[range])
                }
                if let range = Range(match.range(at: 3), in: lineStr) {
                    dict["fileName"] = String(lineStr[range])
                }
                if let range = Range(match.range(at: 4), in: lineStr) {
                    dict["lineNumber"] = Int(lineStr[range])
                }
                if let range = Range(match.range(at: 5), in: lineStr) {
                    dict["columnNumber"] = Int(lineStr[range])
                }
                
                result.append(dict)
            }
        }
        return result
    }

    private func initializeSessionReplay(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any], !arguments.isEmpty else {
            result(FlutterError(code: "4", message: "Arguments is null or empty", details: nil))
            return
        }
        print("arguments: \(arguments)")
        do {
            let sessionReplayOptions = try toSessionReplayOptions(parameter: arguments)
            SessionReplay.initializeWithOptions(sessionReplayOptions: sessionReplayOptions)
        } catch {
            result(FlutterError(code: "4", message: "Failed to parse arguments", details: nil))
            return
        }
        
        result("initializeSessionReplay success")
    }

     private func isSessionReplayInitialized(call: FlutterMethodCall, result: @escaping FlutterResult) {
         let isSessionReplayInitialized = SessionReplay.shared.isInitialized()
         result(isSessionReplayInitialized)
     }

     private func isRecording(call: FlutterMethodCall, result: @escaping FlutterResult) {
         let isRecording = SessionReplay.shared.isRecording()
         result(isRecording)
     }

     private func shutdownSessionReplay(call: FlutterMethodCall, result: @escaping FlutterResult) {
         SessionReplay.shared.stopRecording()
         result("shutdownSessionReplay success")
     }

     private func startSessionRecording(call: FlutterMethodCall, result: @escaping FlutterResult) {
         SessionReplay.shared.startRecording()
         result("startSessionRecording success")
     }

     private func stopSessionRecording(call: FlutterMethodCall, result: @escaping FlutterResult) {
         SessionReplay.shared.stopRecording()
         result("stopSessionRecording success")
     }

    private func captureScreenshot(call: FlutterMethodCall,
                                   result: @escaping FlutterResult) {
        let res = SessionReplay.shared.captureEvent(properties: ["event": "screenshot"])
        switch res {
          case .success:
            result("captureScreenshot success")
          case .failure(.skippingEvent):
            // skippingEvent is expected behavior - means no visual change detected
            result("captureScreenshot skipped (no change detected)")
          case .failure(let error):
            Log.d("Error capturing screenshot: \(error)")
            result(FlutterError(code: "4", message: "Error capturing screenshot: \(error)", details: nil))
        }
    }

     private func registerMaskRegion(call: FlutterMethodCall, result: @escaping FlutterResult) {
         guard let regionId = call.arguments as? String, !regionId.isEmpty else {
             result(FlutterError(code: "4", message: "Region ID is null or empty", details: nil))
             return
         }

         SessionReplay.shared.registerMaskRegion(regionId)
         result("registerMaskRegion success")
     }

     private func unregisterMaskRegion(call: FlutterMethodCall, result: @escaping FlutterResult) {
         guard let regionId = call.arguments as? String, !regionId.isEmpty else {
             result(FlutterError(code: "4", message: "Region ID is null or empty", details: nil))
             return
         }

         SessionReplay.shared.unregisterMaskRegion(regionId)
         result("unregisterMaskRegion success")
     }

     private func getSessionReplayFolderPath(call: FlutterMethodCall, result: @escaping FlutterResult) {
         let folderPath = SessionReplay.shared.getSessionReplayFolderPath()
         result(folderPath)
     }
}

extension CxFlutterPlugin: FlutterStreamHandler {
    public func onListen(
        withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
