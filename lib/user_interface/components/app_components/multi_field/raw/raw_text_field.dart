part of '../_src.dart';

class RawTextField extends StatelessWidget {
  static const Radius radius = Radius.circular(99);

  static BorderSide defaultBorderSide = const BorderSide(color: AppColors.grey);
  static BorderSide focusedBorderSide(BorderSide side) =>
      side.copyWith(width: 2);
  static BorderSide errorBorderSide(BorderSide side) =>
      side.copyWith(color: AppColors.red);

  static final InputBorder defaultInputBorder = OutlineInputBorder(
    borderSide: defaultBorderSide,
    borderRadius: const BorderRadius.all(radius),
  );
  static InputBorder effectiveFocusedBorder(InputBorder border) =>
      border.copyWith(borderSide: focusedBorderSide(border.borderSide));
  static InputBorder errorBorder(InputBorder border) =>
      border.copyWith(borderSide: errorBorderSide(border.borderSide));

  const RawTextField({
    required this.controller,
    this.border,
    this.contentPadding,
    this.enabled,
    this.fillColor,
    this.focusedBorder,
    this.focusNode,
    this.hintText,
    this.inputAction,
    this.inputFormatters,
    this.keyboardType,
    this.label,
    this.maxLength,
    this.maxLines = 1,
    this.style,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText,
    this.obscuringCharacter,
    this.onSubmitted,
    this.onEditingComplete,
    this.autofocus = false,
    super.key,
  });

  final InputBorder? border;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? enabled;
  final Color? fillColor;
  final InputBorder? focusedBorder;
  final String? hintText;
  final TextInputAction? inputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? label;
  final int? maxLength;
  final int? maxLines;
  final TextStyle? style;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final String? obscuringCharacter;
  final void Function(String)? onSubmitted;
  final void Function()? onEditingComplete;
  final bool autofocus;

  InputBorder get effectiveBorder => border ?? defaultInputBorder;

  @override
  Widget build(BuildContext context) {
    return buildTextField(context);
  }

  CustomTextField buildTextField(BuildContext context) {
    return CustomTextField(
      controller: controller,
      enabled: enabled,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType ?? TextInputType.text,
      focusNode: focusNode,
      maxLength: maxLength,
      maxLines: maxLines,
      style: style ?? AppStyles.of(context).label.cBlack,
      textInputAction: inputAction ?? TextInputAction.next,
      obscuringCharacter: obscuringCharacter ?? '•',
      obscureText: obscureText ?? false,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 2.h,
          horizontal: 16.w,
        ),
        counter: maxLength != null ? nothing : null,
        hintText: hintText,
        hintStyle: AppStyles.of(context).label.colored(AppColors.grey),
        filled: true,
        fillColor: fillColor ?? AppColors.white.withOpacity(.7),
        labelStyle: AppStyles.of(context).label,
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: effectiveBorder,
        enabledBorder: effectiveBorder,
        focusedBorder: focusedBorder ?? effectiveFocusedBorder(effectiveBorder),
        focusedErrorBorder: effectiveFocusedBorder(
            errorBorder(focusedBorder ?? effectiveBorder)),
        errorBorder: errorBorder(effectiveBorder),
      ),
    );
  }
}
