part of '../_src.dart';

mixin _AppTextFieldMixin on RawTextField {}

class ValidatedAppTextField extends RawValidatedTextField
    with _AppTextFieldMixin {
  ValidatedAppTextField({
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
    super.suffixIcon,
    super.obscureText,
    super.obscuringCharacter,
    super.showErrorText = true,
    super.key,
  });
}

class AppTextField extends RawTextField with _AppTextFieldMixin {
  const AppTextField({
    required super.controller,
    super.focusNode,
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
    super.suffixIcon,
    super.prefixIcon,
    super.onEditingComplete,
    super.onSubmitted,
    super.obscureText,
    super.obscuringCharacter,
    super.key,
  });
}
