import 'package:flutter/material.dart';

class StText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;
  final double? spacing;
  final double? height;

  const StText(this.text,
      {Key? key,
      this.size,
      this.height,
      this.weight,
      this.color,
      this.align,
      this.maxLines,
      this.spacing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      style: TextStyle(
          height: height,
          letterSpacing: spacing ?? 1.3,
          color: color ?? const Color(0xFF080808),
          fontWeight: weight,
          fontSize: size ?? 17),
    );
  }
}
