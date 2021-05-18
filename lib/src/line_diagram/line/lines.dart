import 'package:flutter/material.dart';

class Lines extends CustomPainter {
  // Nested List to store all measuring lines at the same place
  final List<List<Offset>> lines;
  final double width;
  final List<Color> colors;
  final bool labeledAxes;
  // Sizes needed to calculate position of points if axes are labeled
  final Size oldSize;
  final Size newSize;
  final bool labeledLine;
  List<List<Offset>> _animatedLines = [];
  bool _animated = false;

  List<Paint> _linePaints = [];
  List<Path> _paths = [];
  List<List<Offset>> _translatedLines = [];
  List<TextStyle> _textStyles = [];
  Paint _paintTransparent = Paint()
    ..color = Colors.transparent
    ..strokeWidth = 20;
  TextStyle _transparent = TextStyle(
    color: Colors.transparent,
  );

  Lines({
    @required this.lines,
    @required this.width,
    @required this.colors,
    @required this.labeledLine,
    @required this.labeledAxes,
    @required TextStyle textStyle,
    this.oldSize,
    this.newSize,
  }) {
    // Create a List of Paints from the List of Colors
    // to differetiate between multiple measuring lines
    colors.forEach((element) {
      _linePaints.add(Paint()
        ..color = element
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width);

      _textStyles.add(textStyle..copyWith(color: element));
    });
// Calculate the new position of line points if the axes are labeled
    lines.forEach((element) {
      List<Offset> points = [];
      element.forEach((element) {
        points.add(Offset(
          // Points are recalculated by the difference of
          // the actual Size (oldSize) and the displayed Size (newSize)
          // All x coordinates need to be move to the right
          labeledAxes
              ? element.dx * (newSize.width / oldSize.width) +
                  (oldSize.width - newSize.width)
              : element.dx,
          labeledAxes
              ? newSize.height - element.dy * (newSize.height / oldSize.height)
              : oldSize.height - element.dy,
        ));
      });
      _translatedLines.add(points);
    });

    _translatedLines.forEach((element) {
      _paths.add(Path()..addPolygon(element, false));
    });
  }

  Lines.animated({
    @required this.lines,
    @required List<List<Animation<Offset>>> animations,
    @required this.width,
    @required this.colors,
    @required this.labeledLine,
    @required this.labeledAxes,
    @required TextStyle textStyle,
    this.oldSize,
    this.newSize,
  }) {
    _animated = true;

    for (int i = 0; i < animations.length; i++) {
      List<Offset> tempLines = [];
      for (int j = 0; j < animations[i].length; j++) {
        tempLines.add(lines[i][j]);
        tempLines.add(animations[i][j].value);
      }
      _animatedLines.add(tempLines);
    }
    // Create a List of Paints from the List of Colors
    // to differetiate between multiple measuring lines
    colors.forEach((element) {
      _linePaints.add(Paint()
        ..color = element
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width);

      _textStyles.add(textStyle..copyWith(color: element));
    });
// Calculate the new position of line points if the axes are labeled
    _animatedLines.forEach((element) {
      List<Offset> points = [];
      element.forEach((element) {
        points.add(Offset(
          // Points are recalculated by the difference of
          // the actual Size (oldSize) and the displayed Size (newSize)
          // All x coordinates need to be move to the right
          labeledAxes
              ? element.dx * (newSize.width / oldSize.width) +
                  (oldSize.width - newSize.width)
              : element.dx,
          labeledAxes
              ? newSize.height - element.dy * (newSize.height / oldSize.height)
              : oldSize.height - element.dy,
        ));
      });
      _translatedLines.add(points);
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_animated) {
      for (int i = 0; i < _translatedLines.length; i++) {
        for (int j = 0; j < _translatedLines[i].length; j += 2) {
          canvas.drawLine(
            _translatedLines[i][j],
            _translatedLines[i][j + 1],
            _translatedLines[i][j] == _translatedLines[i][j + 1]
                ? _paintTransparent
                : _linePaints[i % _linePaints.length],
          );
        }
      }
    } else {
      for (int i = 0; i < _paths.length; i++) {
        // Cicle through the Paint List if there are more lines than Paints
        canvas.drawPath(_paths[i], _linePaints[i % _linePaints.length]);
      }
    }

    if (labeledLine) {
      if (_animated) {
        for (int i = 0; i < lines.length; i++) {
          for (int j = 1; j < lines[i].length; j++) {
            TextPainter textPainter = TextPainter(
              text: TextSpan(
                text: lines[i][j].dy.toStringAsFixed(1),
                style: _translatedLines[i][(j - 1) * 2] ==
                        _translatedLines[i][(j - 1) * 2 + 1]
                    ? _transparent
                    : _textStyles[i % _textStyles.length],
              ),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
            )..layout();
            textPainter.paint(
              canvas,
              Offset(
                _translatedLines[i][(j - 1) * 2 + 1].dx -
                    (textPainter.width / 2),
                _translatedLines[i][(j - 1) * 2 + 1].dy -
                    (_textStyles[i % _textStyles.length].fontSize / 1.75),
              ),
            );
          }
        }
      } else {
        for (int i = 0; i < lines.length; i++) {
          for (int j = 1; j < lines[i].length; j++) {
            TextPainter textPainter = TextPainter(
              text: TextSpan(
                text: lines[i][j].dy.toStringAsFixed(1),
                style: _textStyles[i % _textStyles.length],
              ),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
            )..layout();
            textPainter.paint(
              canvas,
              Offset(
                _translatedLines[i][j].dx - (textPainter.width / 2),
                _translatedLines[i][j].dy -
                    (_textStyles[i % _textStyles.length].fontSize / 1.75),
              ),
            );
          }
        }
      }
    }

    // canvas.drawPath(_test, _linePaints[3]);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
