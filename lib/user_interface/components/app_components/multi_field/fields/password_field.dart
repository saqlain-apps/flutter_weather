part of '../_src.dart';

mixin _PasswordFieldMixin on RawTextField {
  Widget buildVisibilitySwitch(
    BuildContext context,
    CustomTextField textField, [
    Color? visibilityColor,
  ]) {
    return ValueTransitionedBuilder<bool>(
      initialValue: false,
      builder: (context, value, update, child) {
        final isPasswordVisible = value;
        final switchPasswordVisibility = update;
        textField = textField.copyWith(
          obscureText: !isPasswordVisible,
          decoration: textField.decoration?.copyWith(
            suffixIcon: _TextFieldPasswordVisibilitySwitch(
              isPasswordVisible: isPasswordVisible,
              visibilityColor: visibilityColor,
              onSwitch: () => switchPasswordVisibility(!isPasswordVisible),
            ),
          ),
        );
        return textField;
      },
    );
  }
}

class PasswordField extends RawTextField with _PasswordFieldMixin {
  const PasswordField({
    required super.controller,
    super.border,
    super.contentPadding,
    super.enabled,
    super.fillColor,
    super.focusedBorder,
    super.hintText,
    super.inputAction,
    super.inputFormatters,
    super.keyboardType,
    super.label,
    super.maxLength,
    super.maxLines = 1,
    super.style,
    super.obscuringCharacter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return buildVisibilitySwitch(context, buildTextField(context));
  }
}
