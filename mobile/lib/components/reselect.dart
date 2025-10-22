import 'package:flutter/material.dart';

class ReselectNotifier extends ChangeNotifier {
  void notifyReselect() {
    notifyListeners();
  }
}

class ReselectScope extends InheritedNotifier<ReselectNotifier> {
  const ReselectScope({
    required ReselectNotifier super.notifier,
    required super.child,
    super.key,
  });

  static ReselectNotifier of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ReselectScope>();
    assert(scope != null, 'No ReselectScope found in context');
    return scope!.notifier!;
  }
}

/// Listen to reselect events from [ReselectNotifier].
///
/// Reselect means user tapping on selected icon in bottom navigation bar. Pages probably want to scroll to top
/// or refresh content when reselected.
class ReselectListener extends StatefulWidget {
  final VoidCallback onReselect;
  final Widget child;

  const ReselectListener({
    required this.onReselect,
    required this.child,
    super.key,
  });

  @override
  State<ReselectListener> createState() => _ReselectListenerState();
}

class _ReselectListenerState extends State<ReselectListener> {
  late ReselectNotifier _notifier;

  void _handle() {
    widget.onReselect();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notifier = ReselectScope.of(context);
    _notifier.addListener(_handle);
  }

  @override
  void dispose() {
    _notifier.removeListener(_handle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
