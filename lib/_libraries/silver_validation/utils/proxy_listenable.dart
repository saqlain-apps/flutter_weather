import 'package:flutter/foundation.dart';

class ProxyListenable<T, Q> implements ValueListenable<T> {
  const ProxyListenable(this.original, this.converter);

  final ValueListenable<Q> original;
  final T Function(Q value) converter;

  @override
  void addListener(VoidCallback listener) => original.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      original.removeListener(listener);

  @override
  T get value => converter(original.value);
}
