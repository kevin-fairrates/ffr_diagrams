import 'dart:math';

import 'package:flutter/material.dart';
import './segment.dart';

class Ring extends CustomPainter {
  final Size size;
  final List<double> segmentWeights;
  final double segmentWidth;
  final bool reverse;
  final bool labeledSegments;
  final List<String> segmentlLabels;
  final TextStyle labelStyle;

  List<Segment> _segments = [];
  double _startAngle = -90 * pi / 180;
  List<double> _angles = [];
  Rect _rect;

  Ring({
    @required this.size,
    @required this.segmentWeights,
    @required this.segmentWidth,
    @required this.reverse,
    @required this.labeledSegments,
    @required this.segmentlLabels,
    @required this.labelStyle,
    List<Color> colors,
    List<List<Color>> gradients,
  }) {
    _rect = Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height));

    for (int i = 0; i < segmentWeights.length; i++) {
      _angles.add(_startAngle);

      _startAngle += segmentWeights[i] * 360 * pi / 180;
    }

    for (int i = 0; i < _angles.length; i++) {
      _segments.add(Segment(
        weight: reverse ? -segmentWeights[i] : segmentWeights[i],
        color: gradients == null ? colors[i] : gradients[i][0],
        shader: colors == null
            ? SweepGradient(
                colors: gradients[i],
                transform: GradientRotation(_angles[i] - (6 * pi / 180)),
                endAngle: segmentWeights[i] * 360 * pi / 180,
              ).createShader(_rect)
            : null,
        width: segmentWidth,
        label: segmentlLabels == null ? null : segmentlLabels[i],
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < _segments.length; i++) {
      double endAngle = _segments[i].weight * 360 * pi / 180;

      canvas.drawArc(_rect, _angles[i], endAngle, false,
          _segments[i % _segments.length].paint);

      if (labeledSegments) {
        TextPainter labelPainter = TextPainter(
          text: TextSpan(
            text: _segments[i].label == null
                ? "${(_segments[i].weight * 100)} %"
                : _segments[i].label,
            style: labelStyle,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        )..layout();

        labelPainter.paint(
            canvas,
            Offset(
              size.width / 2,
              size.height / (1 / _segments[i].weight) - labelStyle.fontSize / 2,
            ));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
