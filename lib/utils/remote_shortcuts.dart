import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// RemoteShortcuts
///
/// Wraps a subtree with Shortcuts and Actions that map common remote /
/// keyboard keys (arrow keys + Enter) to focus traversal and activation.
/// - Arrow keys -> move focus in that direction
/// - Enter / Select / Space -> trigger the focused widget's ActivateAction
///
/// Usage: wrap your app's top-level widget (for example, HomePage) with
/// `RemoteShortcuts(child: const HomePage())` so the entire UI responds to
/// remote controls.
class DirectionalFocusIntent extends Intent {
  final TraversalDirection direction;
  const DirectionalFocusIntent(this.direction);
}

class RemoteShortcuts extends StatelessWidget {
  final Widget child;

  const RemoteShortcuts({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        // Arrow keys -> directional focus movement
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const DirectionalFocusIntent(TraversalDirection.up),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const DirectionalFocusIntent(TraversalDirection.down),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): const DirectionalFocusIntent(TraversalDirection.left),
        LogicalKeySet(LogicalKeyboardKey.arrowRight): const DirectionalFocusIntent(TraversalDirection.right),

        // Enter / Select / Space -> activation
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
            onInvoke: (intent) {
              // Move the focus in the requested direction
              FocusScope.of(context).focusInDirection(intent.direction);
              return null;
            },
          ),

          // Use Flutter's built-in ActivateAction to trigger the focused widget.
          ActivateIntent: ActivateAction(),
        },
        child: FocusScope(
          node: FocusScopeNode(),
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}
