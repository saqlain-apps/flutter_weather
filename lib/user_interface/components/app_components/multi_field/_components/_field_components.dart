part of '../_src.dart';

class _TextFieldPasswordVisibilitySwitch extends StatelessWidget {
  const _TextFieldPasswordVisibilitySwitch({
    required this.onSwitch,
    this.visibilityColor,
    this.isPasswordVisible = false,
  });

  final Color? visibilityColor;
  final bool isPasswordVisible;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, top: 15),
      child: InkWell(
          onTap: onSwitch,
          child: Text(
            isPasswordVisible ? "HIDE" : "SHOW",
            style:
                AppStyles.of(context).sSmall.wSemiBold.colored(visibilityColor),
          )),
    );
  }
}
