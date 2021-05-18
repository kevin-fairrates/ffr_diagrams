import 'package:flutter/material.dart';

class HelperLines {
  final List<List<Offset>> lines;
  final Color color;
  final double width;

  Paint _paint;

  Paint get paint => _paint;

  HelperLines({
    @required this.lines,
    @required this.color,
    @required this.width,
  }) {
    // Create the Paint of the helper lines from the given Color
    _paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
  }
}
