import 'dart:math';

import 'package:flutter/material.dart';

import './grid_axis.dart';
import './helper_lines.dart';

class Grid extends CustomPainter {
  final GridAxis gridAxisX;
  final GridAxis gridAxisY;
  final Size size;
  final HelperLines helperLines;

  double _segmentLabelLenght = 0;

  Grid({
    @required this.gridAxisX,
    @required this.gridAxisY,
    @required this.size,
    this.helperLines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    helperLines.lines.forEach((element) {
      canvas.drawLine(element.first, element.last, helperLines.paint);
    });

    canvas.drawLine(gridAxisX.start, gridAxisX.end, gridAxisX.paint);
    canvas.drawLine(gridAxisY.start, gridAxisY.end, gridAxisY.paint);

    _drawAxisSegments(gridAxisX, canvas);
    _drawAxisSegments(gridAxisY, canvas, true);

    if (gridAxisX.labelStyle != null || gridAxisY.labelStyle != null) {
      TextPainter textPainterX = TextPainter(
        text: TextSpan(
          text: gridAxisX.label,
          style: gridAxisX.labelStyle,
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();
      textPainterX.paint(
        canvas,
        Offset(
          (size.width - textPainterX.width + gridAxisX.start.dx) / 2,
          size.height -
              gridAxisX.labelStyle.fontSize +
              (gridAxisX.labeledSegments
                  ? gridAxisX.textStyle.fontSize + 5
                  : 5),
        ),
      );

      canvas.rotate(270 * pi / 180);
      canvas.translate(-size.height, 0);

      TextPainter textPainterY = TextPainter(
        text: TextSpan(
          text: gridAxisY.label,
          style: gridAxisY.labelStyle,
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();
      textPainterY.paint(
        canvas,
        Offset(
          (gridAxisY.start.dy - textPainterY.width) / 2 +
              (size.height - gridAxisY.start.dy),
          -gridAxisY.labelStyle.fontSize / 6 -
              (gridAxisY.labeledSegments ? _segmentLabelLenght + 5 : 5),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawAxisSegments(GridAxis gridAxis, Canvas canvas,
      [bool yAxis = false]) {
    if (gridAxis.segmentCount > 0) {
      for (int i = 0; i < gridAxis.gridAxisSegments.length; i++) {
        canvas.drawLine(
          Offset(
            yAxis ? gridAxis.start.dx : gridAxis.gridAxisSegments[i].value,
            yAxis
                ? size.height - gridAxis.gridAxisSegments[i].value
                : gridAxis.start.dy,
          ),
          Offset(
            yAxis ? gridAxis.start.dx - 5 : gridAxis.gridAxisSegments[i].value,
            yAxis
                ? size.height - gridAxis.gridAxisSegments[i].value
                : gridAxis.start.dy + 5,
          ),
          gridAxis.paint,
        );

        if (gridAxis.labeledSegments) {
          TextPainter segmentTextPainter = TextPainter(
            text: TextSpan(
              text: gridAxis.label == null
                  ? gridAxis.gridAxisSegments[i].value.toStringAsFixed(1)
                  : (yAxis
                          ? size.height / (gridAxis.segmentCount - 1) * i
                          : size.width / (gridAxis.segmentCount - 1) * i)
                      .toStringAsFixed(1),
              style: gridAxis.textStyle,
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          )..layout();
          segmentTextPainter.paint(
            canvas,
            Offset(
              yAxis
                  ? gridAxis.start.dx - segmentTextPainter.width - 10
                  : gridAxis.gridAxisSegments[i].value -
                      (segmentTextPainter.width / 2),
              yAxis
                  ? size.height -
                      (gridAxis.gridAxisSegments[i].value +
                          (gridAxis.textStyle.fontSize / 1.75))
                  : gridAxis.start.dy + 10,
            ),
          );
          _segmentLabelLenght = segmentTextPainter.width;
        }
      }
    }
  }
}
