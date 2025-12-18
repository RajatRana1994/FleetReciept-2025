import 'package:flutter/material.dart';

class AppTexts extends StatefulWidget {
  final String textValue;
  final double fontSize;
  final FontWeight fontWeight;
  final Color fontColor;
  final TextAlign? textAlign; // Optional, default will be null
  final int? maxLines;
  final TextOverflow? textOverflow;

  const AppTexts({
    super.key,
    required this.textValue,
    required this.fontSize,
    required this.fontWeight,
    this.fontColor = Colors.black,
    this.textAlign, // Default is null
    this.maxLines,
    this.textOverflow,
  });

  @override
  State<AppTexts> createState() => _AppTextsState();
}

class _AppTextsState extends State<AppTexts> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.textValue,
      textAlign:
      widget.textAlign ?? TextAlign.start, // Default to start alignment
      maxLines: widget.maxLines, // Limits the number of lines if provided
      overflow: widget.textOverflow ?? TextOverflow.clip,
      style: TextStyle(
        fontSize: widget.fontSize,

        fontWeight: widget.fontWeight,
        color: widget.fontColor,
        fontFamily: 'Poppins',
      ),
    );
  }
}
