# Changelog

## 0.2.0

Version 0.2.0
Release Date: March 9, 2026

* `beforeSend` callback is now optional (performance improvement)
* When `beforeSend` is not provided, events are sent directly without Dart-side processing, avoiding platform channel overhead
* **Migration:** If you previously relied on the implicit default that passed every event through Dart unchanged, set `beforeSend: (event) => event` explicitly; omitting `beforeSend` now skips the Dart round-trip entirely.
* Native iOS SDK upgraded to 2.3.0
* Native Android SDK upgraded to 2.9.3

## 0.1.1

* **Hybrid user interaction:** When user enables `userActions` in options, Dart tracks click/scroll/swipe; iOS always receives `userActions: false` to avoid duplicate events.
* **setUserInteraction:** iOS forwards interaction payload to native SDK (2.2.0). Android forwards via `reportUserInteraction` (native SDK 2.9.0); returns error when `event_name` is missing or when SDK is not initialized (iOS).
* **Context types aligned with native:** EventContext `source`; DeviceContext `operating_system`/`os_version`, `network_connection_type`/`network_connection_subtype`, `user_agent`; ErrorContext `exception_type`; NetworkRequestContext `request_headers`/`response_headers`/`request_payload`/`response_payload`; InteractionContext `target_element`, `element_classes`, `target_element_inner_text`, `scroll_direction` with `toJson()` omitting nulls for beforeSend round-trip.
* Native iOS SDK 2.2.0; native Android SDK 2.9.0.
* Android: compileSdk 36 (plugin and example).

## 0.1.0

Added Android support for `allowedTracingUrls` in `TraceParentInHeader` configurations
Native Android SDK upgraded to 2.7.2
Native iOS SDK upgraded to 2.1.0

## 0.0.21

Added support for session replay

## 0.0.20

Added the AP3 domain as an option for initializing the SDK with

## 0.0.19

**Breaking Change: Flutter SDK Requirement**
* The package now requires Flutter >=3.27.0 (as specified in `pubspec.yaml` environment: `flutter: '>=3.27.0'`)
* This requirement is necessary to support the modern `Color.withValues(alpha: ...)` API, which replaced the deprecated `Color.withOpacity()` method
* The example app has been updated to use `Color.withValues()` for future compatibility
* Native iOS SDK upgraded to 1.5.3
* Bug fix: https://github.com/coralogix/cx-flutter-plugin/issues/37#issue-3715310863
Release Date: Jan 21, 2026

## 0.0.18

Release Date: Dec 10, 2025

Fix bug BUGV2-1468
Native android SDK upgraded to 2.6.3

## 0.0.17

Release Date: Nov 13, 2025

Fix bug BUGV2-1474
Native iOS SDK upgraded to 1.4.0

=======
## 0.1.1

* **Hybrid user interaction:** When user enables `userActions` in options, Dart tracks click/scroll/swipe; iOS always receives `userActions: false` to avoid duplicate events.
* **setUserInteraction:** iOS forwards interaction payload to native SDK (2.2.0). Android forwards via `reportUserInteraction` (native SDK 2.9.0); returns error when `event_name` is missing or when SDK is not initialized (iOS).
* **Context types aligned with native:** EventContext `source`; DeviceContext `operating_system`/`os_version`, `network_connection_type`/`network_connection_subtype`, `user_agent`; ErrorContext `exception_type`; NetworkRequestContext `request_headers`/`response_headers`/`request_payload`/`response_payload`; InteractionContext `target_element`, `element_classes`, `target_element_inner_text`, `scroll_direction` with `toJson()` omitting nulls for beforeSend round-trip.
* Native iOS SDK 2.2.0; native Android SDK 2.9.0.
* Android: compileSdk 36 (plugin and example).

## 0.1.0

Added Android support for `allowedTracingUrls` in `TraceParentInHeader` configurations
Native Android SDK upgraded to 2.7.2
Native iOS SDK upgraded to 2.1.0

## 0.0.21

Added support for session replay

## 0.0.20

Added the AP3 domain as an option for initializing the SDK with

## 0.0.19

**Breaking Change: Flutter SDK Requirement**
* The package now requires Flutter >=3.27.0 (as specified in `pubspec.yaml` environment: `flutter: '>=3.27.0'`)
* This requirement is necessary to support the modern `Color.withValues(alpha: ...)` API, which replaced the deprecated `Color.withOpacity()` method
* The example app has been updated to use `Color.withValues()` for future compatibility
* Native iOS SDK upgraded to 1.5.3
* Bug fix: https://github.com/coralogix/cx-flutter-plugin/issues/37#issue-3715310863
Release Date: Jan 21, 2026

## 0.0.18

Release Date: Dec 10, 2025

Fix bug BUGV2-1468
Native android SDK upgraded to 2.6.3

## 0.0.17

Release Date: Nov 13, 2025

Fix bug BUGV2-1474
Native iOS SDK upgraded to 1.4.0

## 0.0.16

Release Date: Sep 28, 2025

Add sendCustomMeasurement
Native iOS SDK upgraded to 1.2.6

## 0.0.15

Release Date: Sep 21, 2025

Native iOS SDK upgraded to 1.2.5


## 0.0.14

Release Date: Aug 10, 2025

Native iOS SDK upgraded to 1.1.2

## 0.0.13

Release Date: July 24, 2025

* fix: Android plugin now respect setting the userActions interaction to false and thus actually turning it off
Native Android SDK upgraded to 2.4.44

## 0.0.12

Release Date: unknown

* New Feature add support for proxyUrl
* New Feature traceParentInHeader (iOS Only)
Native iOS SDK upgraded to 1.0.26

## 0.0.11

Release Date: June 22, 2025

* Bug fixes
Native iOS SDK upgraded to 1.0.24

## 0.0.10

Release Date: June 17, 2025

* Bug fixes - beforeSend not sending instrumentation in android and iOS
* Crash fix on Android

Native Android SDK upgraded to 2.4.41
Native iOS SDK upgraded to 1.0.23

## 0.0.9

Release Date: May 28, 2025

* Added Android support for the `beforeSend` operation
* Bug fixes and improvements

Native Android SDK upgraded to 2.4.4

## 0.0.8

Release Date: May 27, 2025

Added Android support for newly added methods:
* getLabels()
* getSessionId()
* isInitialized()
* setApplicationContext()
* Disable swizzling for iOS (NetworkOnly)

Added Android support for the beforeSend callback
Breaking changes:
* The 'CxExporterOptions' class 'beforeSend' callback is now asynchronous.

Native iOS SDK upgraded to 1.0.22
Native Android SDK upgraded to 2.4.3

## 0.0.7

Release Date: May 8, 2025

Implemented the following:
* Before Send
* getLabels()
* getSessionId()
* isInitialized()
* setApplicationContext()

Native SDK upgraded to 1.0.21

## 0.0.6

Release Date: April 24, 2025

Fix Crash related to URLSessionInstrumentation.
Navigation instrument was removed from CoralogixOptions
Native SDK upgraded to 1.0.20

## 0.0.5

Release Date: April 8, 2025

Fix issue related to CustomDomainUrl was removed.
Native SDK upgraded to 1.0.18

## 0.0.4

Release Date: February 10, 2025

Fixed bug preventing data to be sent if no custom url was set on Android.

## 0.0.3

Release Date: December 15, 2024

Android implementation added

## 0.0.2

Release Date: November 25, 2024

Enhancements
SDK Initialization Sampling: Introduced sdkSampler, allowing configuration of the SDK's initialization rate as a percentage (0-100%).

FPS Sampling Rate Configuration: Added mobileVitalsFPSSamplingRate to set the frequency of FPS sampling per hour, with a default of once every minute.

Instrumentation Control: Implemented instrumentations, enabling selective activation or deactivation of specific instruments during runtime. By default, all instrumentations are active.

IP Data Collection Toggle: Added collectIPData to control the collection of user IP addresses and geolocation data, defaulting to true.

## 0.0.1

Added Android support for `allowedTracingUrls` in `TraceParentInHeader` configurations
Native Android SDK upgraded to 2.7.2
Native iOS SDK upgraded to 2.1.0