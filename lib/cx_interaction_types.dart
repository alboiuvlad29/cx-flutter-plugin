/// Interaction event types for user action tracking.
enum InteractionEventName {
  click,
  scroll,
  swipe;

  String get value => name;
}

/// Scroll/swipe direction.
enum ScrollDirection {
  up,
  down,
  left,
  right;

  String get value => name;
}

/// Data class representing a user interaction event.
/// 
/// This mirrors the native SDK's InteractionContext structure.
class CxInteractionData {
  /// The type of interaction event.
  final InteractionEventName eventName;

  /// The widget class name (e.g., "ElevatedButton", "GestureDetector").
  final String? elementClasses;

  /// The widget's semantic label or key identifier.
  final String? elementId;

  /// Visible text content of the widget.
  final String? targetElementInnerText;

  /// Scroll or swipe direction (null for tap events).
  final ScrollDirection? scrollDirection;

  /// The resolved target name or widget class name fallback.
  final String targetElement;

  /// Additional custom attributes.
  final Map<String, dynamic>? attributes;

  const CxInteractionData({
    required this.eventName,
    this.elementClasses,
    this.elementId,
    this.targetElementInnerText,
    this.scrollDirection,
    required this.targetElement,
    this.attributes,
  });

  /// Converts the interaction data to a map for sending to native.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'event_name': eventName.value,
      'target_element': targetElement,
    };
    
    if (elementClasses != null && elementClasses!.isNotEmpty) {
      map['element_classes'] = elementClasses;
    }
    
    if (elementId != null && elementId!.isNotEmpty) {
      map['element_id'] = elementId;
      map['target_id'] = elementId; // Android FlutterPluginManager expects target_id
    }
    
    // Only add inner text if it has actual visible text (not icon glyphs)
    if (targetElementInnerText != null) {
      final trimmed = targetElementInnerText!.trim();
      // Filter out icon font characters (Private Use Area: U+E000-U+F8FF)
      final hasRealText = trimmed.isNotEmpty && 
          !trimmed.codeUnits.every((c) => c >= 0xE000 && c <= 0xF8FF);
      if (hasRealText) {
        map['target_element_inner_text'] = trimmed;
      }
    }
    
    if (scrollDirection != null) {
      map['scroll_direction'] = scrollDirection!.value;
    }
    
    if (attributes != null) {
      map['attributes'] = attributes;
    }
    
    return map;
  }

  @override
  String toString() {
    return 'CxInteractionData(eventName: $eventName, targetElement: $targetElement, '
        'elementClasses: $elementClasses, elementId: $elementId, '
        'scrollDirection: $scrollDirection)';
  }
}
