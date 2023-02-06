import 'package:flutter/material.dart';

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var firstControlPoint = Offset(size.width / 2.5, 50.0);
    var firstEndPoint = Offset(size.width / 2, 10.0);
    var secondControlPoint = Offset(size.width - (size.width / 2.5), 50);
    var secondEndPoint = Offset(size.width, 50);
    var path = Path()
      ..lineTo(0, 10)
      ..lineTo(0, 10)
      ..cubicTo(0, 10, 0, 10, 10, 0)
      ..quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy)
      ..quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy)
      ..lineTo(size.width - 20, 50)
      ..cubicTo(size.width - 20, 50, size.width, 50, size.width, 70)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
