import 'package:cx_flutter_plugin/cx_flutter_plugin.dart';
import 'package:cx_flutter_plugin/cx_instrumentation_type.dart';
import 'package:flutter/material.dart';

class InteractionDemoPage extends StatefulWidget {
  const InteractionDemoPage({super.key});

  @override
  State<InteractionDemoPage> createState() => _InteractionDemoPageState();
}

class _InteractionDemoPageState extends State<InteractionDemoPage> {
  final List<String> _events = [];
  bool _isDismissibleVisible = true;

  bool get _isUserActionsEnabled {
    final options = CxFlutterPlugin.globalOptions;
    if (options == null) return false;
    
    final instrumentations = options.instrumentations;
    if (instrumentations == null) return false;
    
    return instrumentations[CXInstrumentationType.userActions.value] == true;
  }

  @override
  void initState() {
    super.initState();
    CxFlutterPlugin.setView('Interaction Demo');
  }

  void _addEvent(String event) {
    setState(() {
      _events.insert(0, '${DateTime.now().toString().substring(11, 19)} - $event');
      if (_events.length > 20) {
        _events.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget content = Scaffold(
      appBar: AppBar(
        title: const Text('Interaction Demo'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tracking status banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: _isUserActionsEnabled
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isUserActionsEnabled ? Icons.visibility : Icons.visibility_off,
                    color: _isUserActionsEnabled ? Colors.green : Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isUserActionsEnabled
                        ? 'userActions instrumentation is ON'
                        : 'userActions instrumentation is OFF',
                    style: TextStyle(
                      color: _isUserActionsEnabled ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Click Testing Section
                    _SectionTitle(
                      icon: Icons.touch_app,
                      title: 'Click Testing',
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    
                    // Various button types for testing
                    ElevatedButton(
                      key: const ValueKey('elevated_btn'),
                      onPressed: () => _addEvent('ElevatedButton clicked'),
                      child: const Text('Elevated Button'),
                    ),
                    const SizedBox(height: 8),
                    
                    FilledButton(
                      key: const ValueKey('filled_btn'),
                      onPressed: () => _addEvent('FilledButton clicked'),
                      child: const Text('Filled Button'),
                    ),
                    const SizedBox(height: 8),
                    
                    OutlinedButton(
                      key: const ValueKey('outlined_btn'),
                      onPressed: () => _addEvent('OutlinedButton clicked'),
                      child: const Text('Outlined Button'),
                    ),
                    const SizedBox(height: 8),
                    
                    TextButton(
                      key: const ValueKey('text_btn'),
                      onPressed: () => _addEvent('TextButton clicked'),
                      child: const Text('Text Button'),
                    ),
                    const SizedBox(height: 8),
                    
                    // IconButton
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          key: const ValueKey('icon_btn_favorite'),
                          icon: const Icon(Icons.favorite),
                          onPressed: () => _addEvent('Favorite icon clicked'),
                          color: Colors.red,
                        ),
                        IconButton(
                          key: const ValueKey('icon_btn_share'),
                          icon: const Icon(Icons.share),
                          onPressed: () => _addEvent('Share icon clicked'),
                        ),
                        IconButton(
                          key: const ValueKey('icon_btn_bookmark'),
                          icon: const Icon(Icons.bookmark),
                          onPressed: () => _addEvent('Bookmark icon clicked'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Card with InkWell
                    Card(
                      key: const ValueKey('interactive_card'),
                      child: InkWell(
                        onTap: () => _addEvent('Card tapped'),
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.credit_card),
                              SizedBox(width: 12),
                              Text('Tappable Card'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Alert Dialog Button
                    ElevatedButton.icon(
                      key: const ValueKey('alert_btn'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Alert'),
                              content: const Text('This is a simple alert dialog.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _addEvent('Alert dismissed');
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                        _addEvent('Alert shown');
                      },
                      icon: const Icon(Icons.warning_amber),
                      label: const Text('Show Alert'),
                    ),
                    const SizedBox(height: 24),
                    
                    // Scroll Testing Section
                    const _SectionTitle(
                      icon: Icons.swap_vert,
                      title: 'Scroll Testing',
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    
                    // Horizontal scroll view
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        key: const ValueKey('horizontal_list'),
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            key: ValueKey('scroll_item_${index + 1}'),
                            onTap: () => _addEvent('Item ${index + 1} tapped'),
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.primaries[index % Colors.primaries.length]
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Item ${index + 1}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Text(
                      'Scroll horizontally above or vertically on this page',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    
                    // Swipe Testing Section
                    const _SectionTitle(
                      icon: Icons.swipe,
                      title: 'Swipe Testing',
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 12),
                    
                    // Dismissible item
                    if (_isDismissibleVisible)
                      Dismissible(
                        key: const ValueKey('dismissible_item'),
                        onDismissed: (direction) {
                          _addEvent('Item swiped ${direction.name}');
                          setState(() {
                            _isDismissibleVisible = false;
                          });
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.green,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.archive, color: Colors.white),
                        ),
                        child: const Card(
                          child: ListTile(
                            leading: Icon(Icons.mail),
                            title: Text('Swipe me left or right'),
                            subtitle: Text('Dismissible widget demo'),
                          ),
                        ),
                      )
                    else
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isDismissibleVisible = true;
                          });
                        },
                        child: const Text('Reset Dismissible'),
                      ),
                    const SizedBox(height: 24),
                    
                    // Manual Interaction Reporting Section
                    const _SectionTitle(
                      icon: Icons.code,
                      title: 'Manual Reporting',
                      color: Colors.teal,
                    ),
                    const SizedBox(height: 12),
                    
                    ElevatedButton.icon(
                      key: const ValueKey('manual_report_btn'),
                      onPressed: () async {
                        try {
                          await CxFlutterPlugin.setUserInteraction({
                            'event_name': 'click',
                            'element_classes': 'CustomButton',
                            'element_id': 'manual_report_btn',
                            'target_element_inner_text': 'Manual Report',
                            'target_element': 'ManualReportButton',
                            'attributes': {
                              'custom_key': 'custom_value',
                              'timestamp': DateTime.now().millisecondsSinceEpoch,
                            },
                          });
                          _addEvent('Manual interaction reported');
                        } catch (e) {
                          _addEvent('Error reporting interaction: $e');
                        }
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Report Manual Interaction'),
                    ),
                    const SizedBox(height: 24),
                    
                    // Event Log Section
                    _SectionTitle(
                      icon: Icons.list_alt,
                      title: 'Event Log',
                      color: colorScheme.secondary,
                    ),
                    const SizedBox(height: 12),
                    
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      child: _events.isEmpty
                          ? Center(
                              child: Text(
                                'Interact with elements above\nto see events here',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: _events.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    _events[index],
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 8),
                    
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _events.clear();
                        });
                      },
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Clear Log'),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Interaction tracking is now automatic when userActions is enabled
    return content;
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionTitle({
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
