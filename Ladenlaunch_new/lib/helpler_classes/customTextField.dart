import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  bool obscureText;
  final bool isReadOnly;
  final int? maxLine;
  final int? maxLength;
  final TextInputType keyboardType;
  final Widget? prefix;
  final Color? backgroundColor;
  final bool isFromPassword;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  // 🔹 New parameters
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Color focusedBorderColor;

  CustomTextField({
    super.key,
    required this.hintText,
    this.maxLength,
    this.controller,
    this.maxLine,
    this.obscureText = false,
    this.isReadOnly = false,
    this.keyboardType = TextInputType.text,
    this.prefix,
    this.backgroundColor = Colors.white,
    this.isFromPassword = false,
    this.suffix,
    this.inputFormatters,
    this.onChanged,
    this.borderRadius = 10, // default
    this.borderWidth = 1,   // default
    this.borderColor = Colors.transparent, // default
    this.focusedBorderColor = Colors.transparent, // default
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: widget.maxLength,
      readOnly: widget.isReadOnly,
      inputFormatters: widget.inputFormatters,
      textCapitalization: TextCapitalization.sentences,
      enableInteractiveSelection: !widget.isReadOnly,
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLine ?? 1,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        counterText: '',
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Colors.black38,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: widget.backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.focusedBorderColor,
            width: widget.borderWidth + 0.5, // slightly thicker when focused
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        prefixIcon: widget.prefix,
        suffixIcon: widget.isFromPassword
            ? IconButton(
          icon: Icon(
            widget.obscureText ? Icons.visibility_off : Icons.visibility,
            color: widget.focusedBorderColor,
          ),
          onPressed: () {
            setState(() {
              widget.obscureText = !widget.obscureText;
            });
          },
        )
            : widget.suffix,
      ),
    );
  }
}
