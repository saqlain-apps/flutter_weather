import 'package:flutter/material.dart';

class ValueTransitionedBuilder<T> extends StatefulWidget {
  const ValueTransitionedBuilder({
    required this.initialValue,
    required this.builder,
    this.child,
    super.key,
  });

  final T initialValue;
  final Widget Function(
    BuildContext context,
    T value,
    void Function(T newValue) update,
    Widget? child,
  ) builder;
  final Widget? child;

  @override
  State<ValueTransitionedBuilder<T>> createState() =>
      _ValueTransitionedBuilderState<T>();
}

class _ValueTransitionedBuilderState<T>
    extends State<ValueTransitionedBuilder<T>> {
  late final ValueNotifier<T> _value;

  @override
  void initState() {
    super.initState();
    _value = ValueNotifier(widget.initialValue);
  }

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  void update(T newValue) => _value.value = newValue;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: _value,
      builder: (context, value, child) {
        return widget.builder(context, value, update, child);
      },
      child: widget.child,
    );
  }
}
