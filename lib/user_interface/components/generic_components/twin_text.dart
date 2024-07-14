import '../../../utils/app_helpers/_app_helper_import.dart';

enum TwinTextType { tagged, spaced, comma, vertical }

class TwinText extends StatelessWidget {
  const TwinText({
    required this.tag,
    required this.value,
    this.type = TwinTextType.tagged,
    this.tagStyle,
    this.valueStyle,
    this.maxLines,
    super.key,
  });

  final TwinTextType type;

  final String tag;
  final String value;

  final TextStyle? tagStyle;
  final TextStyle? valueStyle;

  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TwinTextType.tagged:
        return _tagged;
      case TwinTextType.spaced:
        return _spaced;
      case TwinTextType.comma:
        return _comma;
      case TwinTextType.vertical:
        return _vertical;
    }
  }

  Widget get _tagged {
    return Builder(builder: (context) {
      return RichText(
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$tag: ',
              style: tagStyle ?? AppStyles.of(context),
            ),
            TextSpan(
              text: value,
              style: valueStyle ?? AppStyles.of(context).wSemiBold,
            ),
          ],
        ),
      );
    });
  }

  Widget get _spaced {
    return Builder(builder: (context) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tag,
            style: tagStyle ?? AppStyles.of(context),
          ),
          const Gap(10),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: valueStyle ?? AppStyles.of(context).wSemiBold,
              ),
            ),
          )
        ],
      );
    });
  }

  Widget get _comma {
    return Builder(builder: (context) {
      return RichText(
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$tag, ',
              style: tagStyle ?? AppStyles.of(context),
            ),
            TextSpan(
              text: value,
              style: valueStyle ?? AppStyles.of(context).wSemiBold,
            ),
          ],
        ),
      );
    });
  }

  Widget get _vertical {
    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tag,
            style: tagStyle ?? AppStyles.of(context),
          ),
          const Gap(4),
          Text(
            value,
            style: valueStyle ?? AppStyles.of(context).wSemiBold,
          ),
        ],
      );
    });
  }
}
