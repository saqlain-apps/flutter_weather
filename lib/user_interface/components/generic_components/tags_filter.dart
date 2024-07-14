import '../../../_libraries/separator_builder.dart';
import '../../../utils/app_helpers/_app_helper_import.dart';

class TagsFilter extends StatefulWidget {
  const TagsFilter({
    required this.filters,
    required this.onUpdateFilter,
    this.selectedFilter,
    this.scrollable = false,
    this.expandChips = true,
    this.externalBuilder,
    super.key,
  });

  factory TagsFilter.scrollable({
    required List<String> filters,
    required void Function(String? selectedFilter) onUpdateFilter,
    String? selectedFilter,
  }) {
    return TagsFilter(
      filters: filters,
      onUpdateFilter: onUpdateFilter,
      selectedFilter: selectedFilter,
      scrollable: true,
      externalBuilder: scrollIndicatorBuilder,
    );
  }

  final List<String> filters;
  final void Function(String? selectedFilter) onUpdateFilter;
  final bool scrollable;
  final bool expandChips;
  final String? selectedFilter;

  final Widget Function(
    BuildContext context,
    ScrollController? controller,
    Widget filter,
  )? externalBuilder;

  @override
  State<TagsFilter> createState() => _TagsFilterState();

  static Widget icon(IconData icon, [Color? color]) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: AppColors.white.withOpacity(.2),
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Center(
          child: Icon(
            icon,
            size: 12,
            color: color ?? AppColors.white,
          ),
        ),
      ),
    );
  }

  static Widget scrollIndicatorBuilder(
      BuildContext context, ScrollController? controller, Widget filter,
      [Color? color]) {
    if (controller == null) return filter;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      controller.notifyListeners();
    });

    void scroll(double offset) {
      controller.animateTo(
        controller.offset + offset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        var shouldShowScrollIndicators =
            controller.hasClients && controller.position.maxScrollExtent > 0;
        return shouldShowScrollIndicators ? child! : filter;
      },
      child: Row(
        children: [
          InkWell(
            onTap: () {
              scroll(-controller.position.maxScrollExtent / 5);
            },
            customBorder: const CircleBorder(),
            child: CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.white.withOpacity(.2),
              child: const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 12,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
          const Gap(5),
          Expanded(child: filter),
          const Gap(5),
          InkWell(
            onTap: () {
              scroll(controller.position.maxScrollExtent / 5);
            },
            customBorder: const CircleBorder(),
            child: CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.white.withOpacity(.2),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagsFilterState extends State<TagsFilter> {
  ScrollController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.scrollable) {
      _controller = ScrollController();
    }
  }

  @override
  void didUpdateWidget(covariant TagsFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollable && _controller == null) {
      _controller = ScrollController();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filters.isEmpty) return nothing;

    Widget filter;

    var separator = SeparatorBuilder<String, Widget>(
      originalList: widget.filters,
      separatorBuilder: (index) => const SizedBox(width: 8),
      itemBuilder: (index, itemData) {
        var isSelected = itemData == widget.selectedFilter;
        var result = Tag(
          tagName: itemData,
          isSelected: isSelected,
          onTap: () => widget.onUpdateFilter(isSelected ? null : itemData),
        );

        if (!widget.scrollable) {
          return widget.expandChips ? Expanded(child: result) : result;
        }

        return result;
      },
    );

    if (widget.scrollable) {
      filter = SizedBox(
        height: 32,
        child: CustomScrollView(
          controller: _controller,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => separator.itemBuilder(index),
                childCount: separator.length,
              ),
            ),
          ],
        ),
      );
    } else {
      filter = Row(children: separator.separatedList);
    }

    return widget.externalBuilder?.call(context, _controller, filter) ?? filter;
  }
}

class Tag extends StatelessWidget {
  const Tag({
    required this.tagName,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String tagName;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: isSelected ? AppColors.white : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: AppColors.white.withOpacity(0.6), width: 1.5),
      ),
      onPressed: onTap,
      child: Center(
        child: Text(
          tagName,
          style: AppStyles.of(context).wSemiBold.copyWith(
                color: isSelected
                    ? AppColors.black
                    : AppColors.white.withOpacity(0.6),
              ),
        ),
      ),
    );
  }
}
