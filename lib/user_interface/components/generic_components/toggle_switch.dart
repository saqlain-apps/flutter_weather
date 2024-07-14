import '/_libraries/separator_builder.dart';
import '/utils/app_helpers/_app_helper_import.dart';

class ToggleSwitch extends StatelessWidget {
  const ToggleSwitch({
    required this.builder,
    required this.currentIndex,
    required this.length,
    this.container = defaultContainer,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.start,
    super.key,
  });

  final Widget Function(
    BuildContext context,
    int index,
    bool isSelected,
  ) builder;
  final int currentIndex;
  final int length;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;

  final Widget Function(BuildContext context, Widget child) container;

  @override
  Widget build(BuildContext context) {
    return container(
      context,
      Row(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        children: SeparatorBuilder<int, Widget>(
          originalList: List.generate(length, (index) => index),
          separatorBuilder: (index) => Gap(2.w),
          itemBuilder: (index, itemData) {
            var isSelected = index == currentIndex;
            return builder(context, index, isSelected);
          },
        ).separatedList,
      ),
    );
  }

  static Widget defaultContainer(BuildContext context, Widget child) {
    return Container(
      height: 40,
      padding: EdgeInsets.all(4.r),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99.r),
      ),
      child: child,
    );
  }
}
