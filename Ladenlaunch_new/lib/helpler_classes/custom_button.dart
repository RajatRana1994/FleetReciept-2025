import 'package:flutter/material.dart';
import 'package:ladenlaunch/helpler_classes/app_colors.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.height = 56.0,
    this.radius = 15.0,
    this.onTap,
    this.btnColor = AppColors.appColor,
    this.btnTextColor = Colors.white,
    this.borderWidth = 0.0,
    this.borderColor = Colors.transparent,
    this.fontSize = 17,
    this.fontWeight = FontWeight.w700,
    this.underline = false,
    this.leading,
    this.trailing,
    this.horizontalPadding,
    this.isLeftAlign = false, // new flag
  });

  final String title;
  final double height;
  final double radius;
  final VoidCallback? onTap;
  final Color btnColor;
  final Color btnTextColor;
  final double borderWidth;
  final Color borderColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool underline;
  final Widget? leading;
  final Widget? trailing;
  final double? horizontalPadding;
  final bool isLeftAlign;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLeftAlign) {
      // Left-align layout with leading/trailing
      return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding ?? 16),
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.btnColor,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
          ),
          child: Row(
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.btnTextColor,
                    fontSize: widget.fontSize,
                    fontWeight: widget.fontWeight,
                    fontFamily: 'Poppins',
                    decoration: widget.underline
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationColor: widget.btnTextColor,
                  ),
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      );
    }

    // Default centered layout
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding ?? 16),
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.btnColor,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 8),
              ],
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.btnTextColor,
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,
                  fontFamily: 'Poppins',
                  decoration: widget.underline
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: widget.btnTextColor,
                ),
              ),
              if (widget.trailing != null) ...[
                const SizedBox(width: 8),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

