import 'package:flutter/material.dart';

class Segment {
  final double weight;
  final double width;
  final Color color;
  final Shader shader;
  final String label;

  Paint _paint;

  Paint get paint => _paint;

  Segment({
    @required this.weight,
    @required this.width,
    @required this.label,
    this.color,
    this.shader,
  }) {
    _paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..shader = shader;
  }
}
