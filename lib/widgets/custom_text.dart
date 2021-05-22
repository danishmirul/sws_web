import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final Color bgColor;
  final FontWeight weight;

  CustomText(
      {@required this.text, this.size, this.color, this.bgColor, this.weight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: size ?? 16,
          color: color ?? Colors.black,
          fontWeight: weight ?? FontWeight.normal,
          backgroundColor: bgColor ?? Colors.transparent),
    );
  }
}
