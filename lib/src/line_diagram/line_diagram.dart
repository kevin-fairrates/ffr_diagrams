import 'package:flutter/material.dart';

import './grid/grid.dart';
import './grid/grid_axis.dart';
import './grid/helper_lines.dart';
import './line/lines.dart';

class LineDiagram extends StatefulWidget {
  final Size size;
  final double gridAxisWidth;
  final Color gridAxisColor;
  final int girdAxisSegmentCountX;
  final int girdAxisSegmentCountY;
  final bool labeledSegments;
  final TextStyle textStyle;

  final List<List<Offset>> lines;
  final List<Color> lineColors;
  final double lineWidth;
  final bool labeledLines;
  final bool animateLines;
  final Duration animationDuration;

  final int helperLineCountX;
  final int helperLineCountY;
  final Color helperLineColor;

  TextStyle _labelStyle;
  bool _labeledAxes = false;
  String _gridAxisLabelX;
  String _gridAxisLabelY;

  Offset _startGridAxisX;
  Offset _endGridAxisX;
  Offset _startGridAxisY;
  Offset _endGridAxisY;

  double _paddingHorizontal = 0;

  LineDiagram({
    @required this.size,
    @required this.lines,
    this.gridAxisWidth = 5,
    this.lineWidth = 5,
    this.lineColors = const [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
    ],
    this.labeledLines = false,
    this.animateLines = false,
    this.animationDuration = const Duration(milliseconds: 3000),
    this.gridAxisColor = Colors.black,
    this.girdAxisSegmentCountX = 0,
    this.girdAxisSegmentCountY = 0,
    this.labeledSegments = false,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    this.helperLineCountX = 0,
    this.helperLineCountY = 0,
    this.helperLineColor = Colors.grey,
  }) {
    _startGridAxisX = Offset(
      0,
      size.height,
    );
    _endGridAxisX = Offset(
      size.width,
      size.height,
    );
    _startGridAxisY = Offset(
      0,
      size.height,
    );
    _endGridAxisY = Offset(
      0,
      0,
    );

// Add origin point to lines
    lines.forEach((element) {
      element.insert(0, Offset(0, 0));
    });

    TextPainter _painter = TextPainter(
      text: TextSpan(
        text: size.height.toStringAsFixed(1),
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    _paddingHorizontal = _painter.width * 1.3 + 2.5;
  }

  LineDiagram.labeled({
    @required this.size,
    @required this.lines,
    @required String gridAxisLabelX,
    @required String gridAxisLabelY,
    this.gridAxisWidth = 5,
    this.lineWidth = 5,
    this.lineColors = const [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
    ],
    this.labeledLines = false,
    this.animateLines = false,
    this.animationDuration = const Duration(milliseconds: 3000),
    this.gridAxisColor = Colors.black,
    this.girdAxisSegmentCountX = 0,
    this.girdAxisSegmentCountY = 0,
    this.labeledSegments = false,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    this.helperLineCountX = 0,
    this.helperLineCountY = 0,
    this.helperLineColor = Colors.grey,
    TextStyle labelStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 32,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
  }) {
    _labeledAxes = true;

    this._gridAxisLabelX = gridAxisLabelX;
    this._gridAxisLabelY = gridAxisLabelY;

    this._labelStyle = labelStyle;

    _startGridAxisX = Offset(
      0 + _labelStyle.fontSize,
      size.height - _labelStyle.fontSize,
    );
    _endGridAxisX = Offset(
      size.width,
      size.height - _labelStyle.fontSize,
    );
    _startGridAxisY = Offset(
      0 + _labelStyle.fontSize,
      size.height - _labelStyle.fontSize,
    );
    _endGridAxisY = Offset(
      0 + _labelStyle.fontSize,
      0,
    );

// Add origin point to lines
    lines.forEach((element) {
      element.insert(0, Offset(0, 0));
    });

    _paddingHorizontal = _labelStyle.fontSize + 5;
  }

  @override
  _LineDiagramState createState() => _LineDiagramState();
}

class _LineDiagramState extends State<LineDiagram>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  List<List<Animation<Offset>>> _animations = [];

  @override
  void initState() {
    super.initState();

    if (widget.animateLines) {
      _controller = AnimationController(
        vsync: this,
        duration: widget.animationDuration,
      );

      widget.lines.forEach((element) {
        List<Animation<Offset>> singleLineAnimation = [];
        double interval = 1 / element.length;
        for (int i = 0; i < element.length - 1; i++) {
          singleLineAnimation.add(Tween<Offset>(
            begin: element[i],
            end: element[i + 1],
          ).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(interval * i, interval * (i + 1)),
            ),
          ));
        }
        _animations.add(singleLineAnimation);
      });

      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.labeledSegments ? widget._paddingHorizontal : 0,
        vertical: widget.labeledSegments
            ? widget.textStyle.fontSize +
                (widget._labeledAxes ? widget._labelStyle.fontSize : 0)
            : 0,
      ),
      child: widget.animateLines
          ? AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, _) {
                return CustomPaint(
                  size: widget.size,
                  // Paint the measuring lines at the under the grid
                  painter: Lines.animated(
                    lines: widget.lines,
                    animations: _animations,
                    colors: widget.lineColors,
                    width: widget.lineWidth,
                    labeledAxes: widget._labeledAxes,
                    textStyle: widget.textStyle,
                    oldSize: widget.size,
                    newSize: widget._labeledAxes
                        ? Size(
                            widget.size.width - widget._labelStyle.fontSize,
                            widget.size.height - widget._labelStyle.fontSize,
                          )
                        : null,
                    labeledLine: widget.labeledLines,
                  ),
                  // Paint the grid over the measuring lines
                  foregroundPainter: Grid(
                    gridAxisX: GridAxis(
                      width: widget.gridAxisWidth,
                      color: widget.gridAxisColor,
                      start: widget._startGridAxisX,
                      end: widget._endGridAxisX,
                      segmentCount: widget.girdAxisSegmentCountX,
                      labeledSegments: widget.labeledSegments,
                      textStyle: widget.textStyle,
                      label: widget._gridAxisLabelX,
                      labelStyle: widget._labelStyle,
                    ),
                    gridAxisY: GridAxis(
                      width: widget.gridAxisWidth,
                      color: widget.gridAxisColor,
                      start: widget._startGridAxisY,
                      end: widget._endGridAxisY,
                      segmentCount: widget.girdAxisSegmentCountY,
                      labeledSegments: widget.labeledSegments,
                      textStyle: widget.textStyle,
                      label: widget._gridAxisLabelY,
                      labelStyle: widget._labelStyle,
                    ),
                    size: widget.size,
                    helperLines: _createHelperLines(widget._labeledAxes),
                  ),
                );
              },
            )
          : CustomPaint(
              size: widget.size,
              // Paint the measuring lines at the under the grid
              painter: Lines(
                lines: widget.lines,
                colors: widget.lineColors,
                width: widget.lineWidth,
                labeledAxes: widget._labeledAxes,
                textStyle: widget.textStyle,
                oldSize: widget.size,
                newSize: widget._labeledAxes
                    ? Size(
                        widget.size.width - widget._labelStyle.fontSize,
                        widget.size.height - widget._labelStyle.fontSize,
                      )
                    : null,
                labeledLine: widget.labeledLines,
              ),
              // Paint the grid over the measuring lines
              foregroundPainter: Grid(
                gridAxisX: GridAxis(
                  width: widget.gridAxisWidth,
                  color: widget.gridAxisColor,
                  start: widget._startGridAxisX,
                  end: widget._endGridAxisX,
                  segmentCount: widget.girdAxisSegmentCountX,
                  labeledSegments: widget.labeledSegments,
                  textStyle: widget.textStyle,
                  label: widget._gridAxisLabelX,
                  labelStyle: widget._labelStyle,
                ),
                gridAxisY: GridAxis(
                  width: widget.gridAxisWidth,
                  color: widget.gridAxisColor,
                  start: widget._startGridAxisY,
                  end: widget._endGridAxisY,
                  segmentCount: widget.girdAxisSegmentCountY,
                  labeledSegments: widget.labeledSegments,
                  textStyle: widget.textStyle,
                  label: widget._gridAxisLabelY,
                  labelStyle: widget._labelStyle,
                ),
                size: widget.size,
                helperLines: _createHelperLines(widget._labeledAxes),
              ),
            ),
    );
  }

  HelperLines _createHelperLines(bool labeled) {
    List<List<Offset>> lines = [];

// Calculate distance of helperlines on x axis
// Calulated with one more line than given because first line is drawn under axis
    double _helperLineDistanceX = labeled
        ? (widget.size.width - widget._labelStyle.fontSize) /
            (widget.helperLineCountX + 1)
        : widget.size.width / (widget.helperLineCountX + 1);

// Calculate distance of helperlines on y axis
// Calulated with one more line than given because first line is drawn under axis
    double _helperLineDistanceY = labeled
        ? (widget.size.height - widget._labelStyle.fontSize) /
            (widget.helperLineCountY + 1)
        : widget.size.height / (widget.helperLineCountY + 1);

// Create helper lines on x axis (vertical)
// Loop starts at one because first line (under axis) is not needed
    for (int i = 1; i < widget.helperLineCountX + 1; i++) {
      // Temporarily store start and end point of line
      List<Offset> points = [];
      for (int j = 0; j < 2; j++) {
        points.add(Offset(
          // Lines on the x axis always begin at x = 0
          // Because the entire Diagram is moved to the right if labeled,
          // the lines also need to be moved to display correctly
          _helperLineDistanceX * i + (labeled ? _helperLineDistanceX / 2 : 0),
          widget.size.height * j +
              (labeled
                  ? j == 1
                      ? -widget._labelStyle.fontSize
                      : 0
                  : 0),
        ));
      }
      lines.add(points);
    }

// Create helper lines on y axis (horizontal)
// Loop starts at one because first line (under axis) is not needed
    for (int i = 1; i < widget.helperLineCountY + 1; i++) {
      // Temporarily store start and end point of line
      List<Offset> points = [];
      for (int j = 0; j < 2; j++) {
        points.add(Offset(
          // Lines on the y axis always start at y = 0
          // The Diagram is not moved on the y axis if labeled,
          // so moving the helper lines is not necessary
          widget.size.width * j +
              (labeled
                  ? j == 0
                      ? widget._labelStyle.fontSize
                      : 0
                  : 0),
          _helperLineDistanceY * i,
        ));
      }
      lines.add(points);
    }

    return HelperLines(
      lines: lines,
      color: widget.helperLineColor,
      width: widget.gridAxisWidth / 2,
    );
  }
}
