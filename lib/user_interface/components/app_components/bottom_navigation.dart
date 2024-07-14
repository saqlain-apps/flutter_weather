import '/utils/app_helpers/_app_helper_import.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
    required this.gestureBuilder,
    this.duration = const Duration(milliseconds: 300),
    this.crossAxisAlignment = CrossAxisAlignment.center,
    super.key,
  });

  final CrossAxisAlignment crossAxisAlignment;
  final int currentIndex;
  final List<BottomNavigationItem> destinations;
  final Duration duration;

  final Widget Function(
    BuildContext context,
    VoidCallback onTap,
    Widget child,
  ) gestureBuilder;
  final void Function(int index) onTap;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  Animation<double> get _unselectedAnimation => _controller;
  Animation<double> get _selectedAnimation =>
      Tween<double>(begin: 1, end: 0).animate(_controller);

  int? _selectingIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void didUpdateWidget(covariant BottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    if (oldWidget.currentIndex != widget.currentIndex) {
      _controller.reset();
      _selectingIndex = null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.viewPaddingOf(context).bottom),
      child: Row(
        crossAxisAlignment: widget.crossAxisAlignment,
        children: widget.destinations
            .map((e) => Expanded(child: _destinationTransformer(context, e)))
            .toList(),
      ),
    );
  }

  Widget _destinationTransformer(
    BuildContext context,
    BottomNavigationItem destination,
  ) {
    var index = widget.destinations
        .where((e) => e is! BottomNavigationPlaceholderItem)
        .toList()
        .indexOf(destination);

    void onTap() async {
      if (destination is BottomNavigationAnimatedItem &&
          widget.currentIndex != index) {
        _selectingIndex = index;
        await _controller.forward();
        _selectingIndex = null;
      }
      widget.onTap(index);
    }

    Widget fixedBuilder(BuildContext context) {
      return destination._builder(context, 0);
    }

    Widget child;
    if (index >= 0) {
      child = AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          var isSelected = index == widget.currentIndex;
          var isSelecting = index == _selectingIndex;
          if (isSelected || isSelecting) {
            var animation =
                isSelected ? _selectedAnimation : _unselectedAnimation;
            return destination._builder(context, animation.value);
          } else {
            return fixedBuilder(context);
          }
        },
      );
      child = widget.gestureBuilder(context, onTap, child);
    } else {
      child = fixedBuilder(context);
    }

    return child;
  }
}

sealed class BottomNavigationItem {
  const BottomNavigationItem();

  factory BottomNavigationItem.selection({
    required Widget Function(BuildContext context, bool isSelected) builder,
  }) =>
      BottomNavigationSelectionItem(builder: builder);

  factory BottomNavigationItem.animation({
    required Widget Function(BuildContext context, double animation) builder,
  }) =>
      BottomNavigationAnimatedItem(builder: builder);

  factory BottomNavigationItem.placeholder({
    required Widget Function(BuildContext context) builder,
  }) =>
      BottomNavigationPlaceholderItem(builder: builder);

  Widget _builder(BuildContext context, double animation);
}

class BottomNavigationSelectionItem extends BottomNavigationItem {
  const BottomNavigationSelectionItem({required this.builder});

  final Widget Function(BuildContext context, bool isSelected) builder;

  @override
  Widget _builder(BuildContext context, double animation) {
    var isSelected = animation.round() == 1;
    return builder(context, isSelected);
  }
}

class BottomNavigationAnimatedItem extends BottomNavigationItem {
  const BottomNavigationAnimatedItem({required this.builder});

  final Widget Function(
    BuildContext context,
    double animation,
  ) builder;

  @override
  Widget _builder(BuildContext context, double animation) =>
      builder(context, animation);
}

class BottomNavigationPlaceholderItem extends BottomNavigationItem {
  const BottomNavigationPlaceholderItem({required this.builder});

  final Widget Function(BuildContext context) builder;

  @override
  Widget _builder(BuildContext context, double animation) {
    return builder(context);
  }
}
