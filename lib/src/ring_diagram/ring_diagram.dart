import 'package:flutter/material.dart';
import './ring/ring.dart';

class RingDiagram extends StatefulWidget {
  final Size size;
  final List<double> segmentWeights;
  final double segmentWidth;
  final bool reverse;
  final bool labeledSegments;
  final List<String> segmentLabels;
  final TextStyle labelStyle;

  List<Color> _colors;
  List<List<Color>> _gradients;

  RingDiagram({
    @required this.size,
    @required this.segmentWeights,
    this.segmentWidth = 20,
    List<Color> colors = const [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
    ],
    this.reverse = false,
    this.labeledSegments = false,
    this.segmentLabels,
    this.labelStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 24,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
  }) {
    this._colors = colors;
  }

  RingDiagram.gradient({
    @required this.size,
    @required this.segmentWeights,
    this.segmentWidth = 20,
    this.reverse = false,
    List<List<Color>> gradients = const [
      [
        Colors.red,
        Colors.orange,
      ],
      [
        Colors.orange,
        Colors.yellow,
      ],
      [
        Colors.yellow,
        Colors.green,
      ],
      [
        Colors.green,
        Colors.blue,
      ],
      [
        Colors.blue,
        Colors.red,
      ],
    ],
    this.labeledSegments = false,
    this.segmentLabels,
    this.labelStyle,
  }) {
    this._gradients = gradients;
  }

  @override
  _RingDiagramState createState() => _RingDiagramState();
}

class _RingDiagramState extends State<RingDiagram> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.segmentWidth / 2,
        vertical: widget.segmentWidth / 2,
      ),
      child: CustomPaint(
        size: widget.size,
        painter: Ring(
          size: widget.size,
          segmentWeights: widget.segmentWeights,
          segmentWidth: widget.segmentWidth,
          colors: widget._colors,
          gradients: widget._gradients,
          reverse: widget.reverse,
          labeledSegments: widget.labeledSegments,
          segmentlLabels: widget.segmentLabels,
          labelStyle: widget.labelStyle,
        ),
      ),
    );
  }
}
