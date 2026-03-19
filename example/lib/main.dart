import 'dart:async';
import 'dart:convert';

import 'package:coralogix_sdk/session_replay.dart';
import 'package:cx_flutter_plugin/cx_domain.dart';
import 'package:cx_flutter_plugin/cx_exporter_options.dart';
import 'package:cx_flutter_plugin/cx_http_client.dart';
import 'package:cx_flutter_plugin/cx_instrumentation_type.dart';
import 'package:cx_flutter_plugin/cx_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cx_flutter_plugin/cx_flutter_plugin.dart';
import 'package:cx_flutter_plugin/cx_session_replay_masking.dart';
import 'interaction_demo.dart';
//import 'package:http/io_client.dart';

const channel = MethodChannel('example.flutter.coralogix.io');

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SessionReplayMasking.initialize();
    await dotenv.load();

    runApp(MaterialApp(
      title: 'Coralogix SDK Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MyApp(),
    ));
  }, (error, stackTrace) {
    CxFlutterPlugin.reportError(error.toString(), {}, stackTrace.toString());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _sessionId;
  bool _isLoadingSessionId = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> _loadSessionId() async {
    setState(() {
      _isLoadingSessionId = true;
    });
    try {
      final sessionId = await CxFlutterPlugin.getSessionId();
      if (mounted) {
        setState(() {
          _sessionId = sessionId;
          _isLoadingSessionId = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingSessionId = false;
        });
      }
      debugPrint('Error loading session ID: $e');
    }
  }

  Future<void> _copySessionId() async {
    if (_sessionId != null && _sessionId!.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: _sessionId!));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session ID copied to clipboard'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> initPlatformState() async {
    // Setup the cx SDK
    var userContext = UserMetadata(
      userId: 'user123',
      userName: 'John Doe',
      userEmail: 'john@example.com',
      userMetadata: {'role': 'admin'},
    );

    var coralogixDomain = CXDomain.eu2;

    var options = CXExporterOptions(
      coralogixDomain: coralogixDomain,
      userContext: userContext,
      environment: 'production',
      application: 'demo-app-flutter',
      version: '1.0.0',
      publicKey: dotenv.env['CORALOGIX_PUBLIC_KEY_EU2']!,
      ignoreUrls: [],
      ignoreErrors: [],
      proxyUrl: dotenv.env['CORALOGIX_PROXY_URL'],
      labels: {'item': 'playstation 5', 'itemPrice': 1999},
      sdkSampler: 100,
      mobileVitalsFPSSamplingRate: 150,
      instrumentations: {
        CXInstrumentationType.network.value: true,
        CXInstrumentationType.custom.value: true,
        CXInstrumentationType.errors.value: true,
        CXInstrumentationType.anr.value: false,
        CXInstrumentationType.lifeCycle.value: false,
        CXInstrumentationType.mobileVitals.value: false,
        CXInstrumentationType.userActions.value: true,
      },
      collectIPData: true,
      enableSwizzling: true,
      traceParentInHeader: { 'enable': true,
        'options': {
          'allowedTracingUrls': ['https://jsonplaceholder.typicode.com/posts/']
        }
      },
      debug: true,
    );

    final isInitialize = await CxFlutterPlugin.initSdk(options);
    debugPrint('SDK: $isInitialize');
    await CxFlutterPlugin.setView("Main screen");

    // Load session ID after SDK initialization
    if (mounted) {
      _loadSessionId();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coralogix SDK Demo'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          key: const Key('sdk-options-list'),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Session ID Card
              _SessionIdCard(
                sessionId: _sessionId,
                isLoading: _isLoadingSessionId,
                onCopy: _copySessionId,
                onRefresh: _loadSessionId,
              ),
              const SizedBox(height: 24),
              // Network Operations Section
              _SectionHeader(
                icon: Icons.cloud_outlined,
                title: 'Network Operations',
                color: colorScheme.primary,
              ),
              const SizedBox(height: 12),
              _ActionCard(
                key: const Key('network-success-button'),
                icon: Icons.check_circle_outline,
                title: 'Successful Request',
                subtitle: 'Send a successful network request',
                color: Colors.green,
                onTap: () => sendNetworkRequest('https://jsonplaceholder.typicode.com/posts/'),
              ),
              const SizedBox(height: 8),
              _ActionCard(
                key: const Key('network-failure-button'),
                icon: Icons.error_outline,
                title: 'Failed Request',
                subtitle: 'Send a failed network request',
                color: Colors.red,
                onTap: () => sendNetworkRequest('https://coralogix.com/404'),
              ),
              const SizedBox(height: 24),

              // User & Context Section
              _SectionHeader(
                icon: Icons.person_outline,
                title: 'User & Context',
                color: colorScheme.secondary,
              ),
              const SizedBox(height: 12),
              _ActionCard(
                icon: Icons.account_circle_outlined,
                title: 'Set User Context',
                subtitle: 'Update user metadata',
                color: colorScheme.secondary,
                onTap: sendUserContext,
              ),
              const SizedBox(height: 8),
              _ActionCard(
                icon: Icons.label_outline,
                title: 'Set Labels',
                subtitle: 'Add custom labels',
                color: colorScheme.tertiary,
                onTap: setLabels,
              ),
              const SizedBox(height: 8),
              _ActionCard(
                icon: Icons.label,
                title: 'Get Labels',
                subtitle: 'Retrieve current labels',
                color: colorScheme.tertiary,
                onTap: getLabels,
              ),
              const SizedBox(height: 8),
              _ActionCard(
                icon: Icons.app_settings_alt_outlined,
                title: 'Set Application Context',
                subtitle: 'Update app name and version',
                color: colorScheme.secondary,
                onTap: setApplicationContext,
              ),
              const SizedBox(height: 24),

              // Errors & Logging Section
              const _SectionHeader(
                icon: Icons.bug_report_outlined,
                title: 'Errors & Logging',
                color: Colors.orange,
              ),
              const SizedBox(height: 12),
              const _ActionCard(
                key: Key('report-error-button'),
                icon: Icons.report_problem_outlined,
                title: 'Report Error',
                subtitle: 'Send an error report',
                color: Colors.red,
                onTap: reportError,
              ),
              const SizedBox(height: 8),
              const _ActionCard(
                key: Key('send-error-log-button'),
                icon: Icons.description_outlined,
                title: 'Send Log',
                subtitle: 'Send a custom log message',
                color: Colors.blue,
                onTap: sendLog,
              ),
              const SizedBox(height: 8),
              _ActionCard(
                icon: Icons.rule_outlined,
                title: 'Assert Exception',
                subtitle: 'Trigger an assert failure',
                color: Colors.red,
                onTap: () {
                  assert(false, 'assert failure');
                },
              ),
              const SizedBox(height: 8),
              const _ActionCard(
                key: Key('error-with-custom-labels-button'),
                icon: Icons.warning_amber_outlined,
                title: 'Throw Exception',
                subtitle: 'Throw and catch an exception',
                color: Colors.orange,
                onTap: throwTryCatchInDart,
              ),
              const SizedBox(height: 8),
              const _ActionCard(
                icon: Icons.error_outline,
                title: 'Throw on Pressed',
                subtitle: 'Throw exception on button press',
                color: Colors.red,
                onTap: throwEcexpotionInDart,
              ),
              const SizedBox(height: 8),
              _ActionCard(
                icon: Icons.dangerous_outlined,
                title: 'Swift Fatal Error',
                subtitle: 'Trigger native fatal error',
                color: Colors.deepPurple,
                onTap: () => platformExecute('fatalError'),
              ),
              const SizedBox(height: 24),

              // SDK Management Section
              _SectionHeader(
                icon: Icons.settings_outlined,
                title: 'SDK Management',
                color: colorScheme.primary,
              ),
              const SizedBox(height: 12),
              const _ActionCard(
                icon: Icons.power_settings_new_outlined,
                title: 'SDK Shutdown',
                subtitle: 'Shutdown the SDK',
                color: Colors.grey,
                onTap: sdkShutdown,
              ),
              const SizedBox(height: 8),
              const _ActionCard(
                icon: Icons.check_circle,
                title: 'Is Initialized',
                subtitle: 'Check SDK initialization status',
                color: Colors.green,
                onTap: isInitialized,
              ),
              const SizedBox(height: 8),
              _ActionCard(
                icon: Icons.fingerprint_outlined,
                title: 'Get Session ID',
                subtitle: 'Retrieve current session ID',
                color: colorScheme.primary,
                onTap: getSessionId,
              ),
              const SizedBox(height: 8),
              const _ActionCard(
                key: Key('send-custom-measurement-button'),
                icon: Icons.analytics_outlined,
                title: 'Custom Measurement',
                subtitle: 'Send a custom measurement',
                color: Colors.teal,
                onTap: sendCustomMeasurement,
              ),
              const SizedBox(height: 8),
              _ActionCard(
                key: const Key('verify-logs-button'),
                icon: Icons.verified_outlined,
                title: 'Verify Logs',
                subtitle: 'Validate logs for current session',
                color: Colors.blue,
                onTap: () => verifyLogs(context),
              ),
              const SizedBox(height: 24),

              // Navigation Section
              _SectionHeader(
                icon: Icons.navigation_outlined,
                title: 'Navigation',
                color: colorScheme.tertiary,
              ),
              const SizedBox(height: 12),
              _ActionCard(
                icon: Icons.open_in_new_outlined,
                title: 'Navigate to New Screen',
                subtitle: 'Open a new screen',
                color: colorScheme.tertiary,
                onTap: () => navigateToNewScreen(context),
              ),
              _ActionCard(
                  icon: Icons.video_library,
                  title: 'Session Replay Options',
                  subtitle: 'Open Session Replay settings',
                  color: Colors.teal,
                  onTap: () => navigateToSessionReplay(context),
              ),
              const SizedBox(height: 8),
              _ActionCard(
                  key: const Key('interaction-demo-button'),
                  icon: Icons.touch_app,
                  title: 'Interaction Tracking Demo',
                  subtitle: 'Test click, scroll & swipe detection',
                  color: Colors.deepPurple,
                  onTap: () => navigateToInteractionDemo(context),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> platformExecute(String method) async {
  await channel.invokeMethod(method);
}

Future<void> throwEcexpotionInDart() async {
  throw Exception('Throws onPressed');
}

Future<void> throwTryCatchInDart() async {
  try {
    throw StateError('state error try catch');
  } catch (error, stackTrace) {
    if (error is StateError) {
      // Handle the StateError
      var result = await CxFlutterPlugin.reportError(error.message, {}, stackTrace.toString());
      debugPrint('$result');
    }
  }
}

Future<void> setApplicationContext() async {
  await CxFlutterPlugin.setApplicationContext('demoApp-flutter2', '8.0.0');
}

Future<void> getSessionId() async {
  final sessionId = await CxFlutterPlugin.getSessionId();
  debugPrint('Session Id: $sessionId');
}

Future<void> setView(String name) async {
  await CxFlutterPlugin.setView(name);
}

Future<void> navigateToNewScreen(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const NewScreen()),
  );
}

Future<void> navigateToSessionReplay(BuildContext context) async {
  try {
    debugPrint('Navigating to Session Replay page...');
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SessionReplayOptionsPage(),
      ),
    );
    debugPrint('Navigation completed');
  } catch (e, stackTrace) {
    debugPrint('Navigation error: $e');
    debugPrint('Stack trace: $stackTrace');
  }
}

Future<void> navigateToInteractionDemo(BuildContext context) async {
  try {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const InteractionDemoPage(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Navigation error: $e');
    debugPrint('Stack trace: $stackTrace');
  }
}

Future<void> sendLog() async {
  await CxFlutterPlugin.log(CxLogSeverity.error, 'this is an error',
      {'fruit': 'banna', 'price': 1.30});
}

Future<void> reportError() async {
  var result = await CxFlutterPlugin.reportError(
      'this is an error', {'fruit': 'banna', 'price': 1.30}, "");
  debugPrint('$result');
}

Future<void> sdkShutdown() async {
  await CxFlutterPlugin.shutdown();
}

Future<void> setLabels() async {
  final labels = {'stock': 'NVDA', 'price': 104};
  await CxFlutterPlugin.setLabels(labels);
}

Future<void> sendCustomMeasurement() async {
  await CxFlutterPlugin.sendCustomMeasurement('test', 1.0);
}

Future<void> verifyLogs(BuildContext context) async {
  try {
    final sessionId = await CxFlutterPlugin.getSessionId();
    if (sessionId == null || sessionId.isEmpty) {
      if (context.mounted) {
        _showAlertDialog(
          context,
          'Error',
          'No session ID available',
          showCopyButton: true,
        );
      }
      return;
    }

    final url = 'https://schema-validator-latest.onrender.com/logs/validate/$sessionId';
    debugPrint('will now fetch logs for: $url');

    http.Response response;
    try {
      response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Request timed out after 30 seconds');
        },
      );
    } on TimeoutException catch (e) {
      debugPrint('Request timeout: $e');
      if (context.mounted) {
        _showAlertDialog(
          context,
          'Error',
          'Request timed out. Please try again.',
          showCopyButton: true,
        );
      }
      return;
    } on Exception catch (e) {
      debugPrint('Request error: $e');
      if (context.mounted) {
        _showAlertDialog(
          context,
          'Error',
          'Failed to fetch logs: $e',
          showCopyButton: true,
        );
      }
      return;
    }

    if (!context.mounted) return;

    if (response.statusCode != 200) {
      debugPrint('Fetch failed with status: ${response.statusCode} ${response.reasonPhrase}');
      _showAlertDialog(
        context,
        'Error',
        'Failed to fetch logs: ${response.statusCode} - ${response.reasonPhrase}',
        showCopyButton: true,
      );
      return;
    }

    final decoded = json.decode(response.body);
    if (decoded is! List) {
      _showAlertDialog(
        context,
        'Error',
        'Unexpected response format: expected a list',
        showCopyButton: true,
      );
      return;
    }
    final data = decoded;
    bool allValid = true;
    List<String> errorMessages = [];

    for (var item in data) {
      try {
        final itemMap = item as Map<String, dynamic>?;
        if (itemMap == null) {
          allValid = false;
          errorMessages.add('Invalid item format: expected map');
          continue;
        }

        final validationResult =
        itemMap['validationResult'] as Map<String, dynamic>?;
        if (validationResult == null) {
          allValid = false;
          errorMessages.add('Missing validationResult in response');
          continue;
        }

        final statusCode = validationResult['statusCode'] as int?;
        if (statusCode == null) {
          allValid = false;
          errorMessages.add('Missing status code in validation result');
          continue;
        }

        // Handle message - it might be a List or String
        final messageValue = validationResult['message'];
        String? message;
        if (messageValue is String) {
          message = messageValue;
        } else if (messageValue is List) {
          // If message is a list, join it
          message = messageValue.map((e) => e.toString()).join(', ');
        } else if (messageValue != null) {
          message = messageValue.toString();
        }

        if (statusCode != 200) {
          allValid = false;
          errorMessages.add(message ?? 'Invalid status code: $statusCode');
        }
      } catch (e, stackTrace) {
        debugPrint('Error processing item: $e');
        debugPrint('Item structure: $item');
        debugPrint('Stack trace: $stackTrace');
        allValid = false;
        errorMessages.add('Error processing validation item: $e');
        // Continue processing other items even if one fails
      }
    }

    if (data.isEmpty) {
      allValid = false;
      errorMessages.add('No logs found for validation.');
    }

    if (allValid) {
      _showAlertDialog(
        context,
        'Success',
        'All logs are valid! ✅',
        showCopyButton: true,
      );
    } else {
      _showAlertDialog(
        context,
        'Validation Failed',
        'Some logs failed validation:\n${errorMessages.join('\n')}',
        showCopyButton: true,
      );
    }
  } catch (error) {
    debugPrint('Verify logs error: $error');
    if (context.mounted) {
      _showAlertDialog(
        context,
        'Error',
        'Failed to verify logs: $error',
        showCopyButton: true,
      );
    }
  }
}

void _showAlertDialog(
  BuildContext context,
  String title,
  String message, {
  bool showCopyButton = false,
}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: SelectableText(message),
        ),
        actions: [
          if (showCopyButton) ...[
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: '$title\n\n$message'));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied to clipboard'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Copy'),
            ),
          ],
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<void> sendUserContext() async {
  var userContext = UserMetadata(
    userId: 'user123',
    userName: 'John Doe',
    userEmail: 'john@example.com',
    userMetadata: {'role': 'admin'},
  );

  await CxFlutterPlugin.setUserContext(userContext);
}

Future<void> getLabels() async {
  try {
    final labels = await CxFlutterPlugin.getLabels();
    if (labels != null) {
      debugPrint('Current labels: $labels');
    } else {
      debugPrint('No labels found');
    }
  } catch (e, stackTrace) {
    debugPrint('Error getting labels: $e');
    debugPrint('Stack trace: $stackTrace');
  }
}

Future<void> isInitialized() async {
  final isInitialized = await CxFlutterPlugin.isInitialized();
  debugPrint('Is Initialized: $isInitialized');
}

Future<void> sendNetworkRequest(String url) async {
  final client = CxHttpClient();
  try {
    await client.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'FlutterApp/1.0', // Many APIs require this!
      },
    );
  } catch (e, stackTrace) {
    debugPrint('Network request failed: $e');
    debugPrint('Stack trace: $stackTrace');
  } finally {
    client.close();
  }
}

//  Future<void> sendNetworkRequest(String url) async {
//   final client = await createCxHttpClientWithProxy(); // ✅ await here

//   try {
//     final response = await client.get(
//       Uri.parse(url),
//       headers: {
//        'Accept': 'application/json',
//        'User-Agent': 'FlutterApp/1.0', // Many APIs require this!
//       },
//    );

//   } catch (e) {
//     debugPrint('Request error: $e');
//   } finally {
//     client.close();
//   }
//  }

// Future<CxHttpClient> createCxHttpClientWithProxy() async {
//   // Use 10.0.2.2 for Android emulator, localhost for iOS simulator
//   final proxy = Platform.isAndroid ? '10.0.2.2:9090' : 'localhost:9090';

//   final httpClient = HttpClient();
//   httpClient.findProxy = (uri) => "PROXY $proxy";
//   httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//   final ioClient = IOClient(httpClient);

//   return CxHttpClient(ioClient);
// }

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionIdCard extends StatelessWidget {
  final String? sessionId;
  final bool isLoading;
  final VoidCallback onCopy;
  final VoidCallback onRefresh;

  const _SessionIdCard({
    required this.sessionId,
    required this.isLoading,
    required this.onCopy,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.fingerprint,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Session ID',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  onPressed: isLoading ? null : onRefresh,
                  tooltip: 'Refresh Session ID',
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (sessionId != null && sessionId!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: SelectableText(
                      sessionId!,
                      key: const Key('session-id'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onCopy,
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copy Session ID'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Session ID not available',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  void initState() {
    super.initState();
    CxFlutterPlugin.setView('New Screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Screen'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionHeader(
                icon: Icons.cloud_outlined,
                title: 'Network Operations',
                color: colorScheme.primary,
              ),
              const SizedBox(height: 12),
              _ActionCard(
                icon: Icons.check_circle_outline,
                title: 'Successful Request',
                subtitle: 'Send a successful network request',
                color: Colors.green,
                onTap: () => sendNetworkRequest('https://jsonplaceholder.typicode.com/todos/1'),
              ),
              const SizedBox(height: 24),
              const _SectionHeader(
                icon: Icons.bug_report_outlined,
                title: 'Error Testing',
                color: Colors.orange,
              ),
              const SizedBox(height: 12),
              _ActionCard(
                icon: Icons.error_outline,
                title: 'Show Scaffold Error',
                subtitle: 'Trigger a scaffold error',
                color: Colors.red,
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(24),
                    child: const Text('Scaffold error', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}