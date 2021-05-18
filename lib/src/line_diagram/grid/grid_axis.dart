import 'package:flutter/material.dart';
import './gird_axis_segment.dart';

class GridAxis {
  final double width;
  final Color color;
  final Offset start;
  final Offset end;
  final String label;
  final TextStyle labelStyle;
  final int segmentCount;
  final bool labeledSegments;
  final TextStyle textStyle;

  Paint _paint;
  List<GridAxisSegment> _gridAxisSegments = [];
  double _segmentDistance = 0;

  Paint get paint => _paint;
  List<GridAxisSegment> get gridAxisSegments => _gridAxisSegments;

  GridAxis({
    @required this.width,
    @required this.start,
    @required this.end,
    @required this.color,
    @required this.segmentCount,
    @required this.labeledSegments,
    this.label,
    this.labelStyle,
    this.textStyle,
  }) {
    // Create the Paint of the axis from the given Color
    _paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    if (segmentCount > 0) {
      if (segmentCount > 1) {
        if (labelStyle == null) {
          if (end.dx == 0) {
            _segmentDistance = start.dy / (segmentCount - 1);
          } else {
            _segmentDistance = end.dx / (segmentCount - 1);
          }
          for (int i = 0; i < segmentCount; i++) {
            _gridAxisSegments.add(GridAxisSegment(value: _segmentDistance * i));
          }
        } else {
          if (end.dx == start.dx) {
            _segmentDistance = start.dy / (segmentCount - 1);
          } else {
            _segmentDistance = (end.dx - start.dx) / (segmentCount - 1);
          }
          for (int i = 0; i < segmentCount; i++) {
            _gridAxisSegments.add(GridAxisSegment(
                value: _segmentDistance * i +
                    (end.dx == start.dx ? labelStyle.fontSize : start.dx)));
          }
        }
      } else {
        if (labelStyle == null) {
          _gridAxisSegments.add(GridAxisSegment(value: 0));
        } else {
          _gridAxisSegments.add(GridAxisSegment(value: start.dx));
        }
      }
    }
  }
}
