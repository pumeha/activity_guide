import 'package:activity_guide/shared/custom_widgets/app_text.dart';
import 'package:activity_guide/shared/utils/colors.dart';
import 'package:flutter/material.dart';

enum ButtonType { elevated, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderSide? borderSide;
  final double? fontSize;
  final Widget? leading;
  final Widget? trailing;
  final bool fullWidth;
  final bool isLoading;
  final bool? bold;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.elevated,
    this.backgroundColor,
    this.textColor,
    this.borderSide,
    this.fontSize = 16,
    this.leading,
    this.trailing,
    this.fullWidth = false,
    this.isLoading = false,
    this.bold = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultTextColor = textColor ??
        (type == ButtonType.outlined
            ? Theme.of(context).primaryColor
            : Colors.white);

    Widget content = isLoading
        ? SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        backgroundColor: active,
        color: Colors.white,
        strokeWidth: 5,
      ),
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 8),
        ],
        AppText(text: text,fontSize: fontSize,bold: bold!,color: defaultTextColor,softWrap: true,),

        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );

    Widget button;
    switch (type) {
      case ButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: borderSide ??
                BorderSide(color: Theme.of(context).primaryColor, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            minimumSize:
            fullWidth ? const Size(double.infinity, 50) : null,
          ),
          child: content,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            minimumSize:
            fullWidth ? const Size(double.infinity, 50) : null,
          ),
          child: content,
        );
        break;
      case ButtonType.elevated:

        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
            backgroundColor ?? Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            minimumSize:
            fullWidth ? const Size(double.infinity, 50) : null,
          ),
          child: content,
        );
    }

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: button,
    );
  }
}


Widget blueButton({
  required VoidCallback onPressed,
  required String title,
  bool fullWidth = true,
  bool isLoading = false,
}) {
  return CustomButton(
    text: title,
    onPressed: onPressed,
    fullWidth: fullWidth,
    isLoading: isLoading,
  );
}
