import 'package:flutter/material.dart';
import 'package:ffr_diagrams/ffr_diagrams.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FFR Diagrams Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('FFR Diagrams Demo'),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LineDiagram(
                  size: Size(200, 200),
                  gridAxisWidth: 5,
                  lines: [
                    [
                      Offset(50, 10),
                      Offset(100, 50),
                      Offset(125, 150),
                      Offset(150, 175),
                      Offset(200, 180),
                    ],
                    [
                      Offset(50, 30),
                      Offset(100, 70),
                      Offset(125, 170),
                      Offset(150, 195),
                      Offset(200, 200),
                    ],
                  ],
                  girdAxisSegmentCountX: 5,
                  girdAxisSegmentCountY: 5,
                  animateLines: true,
                  labeledSegments: true,
                  // helperLineCountX: 3,
                  // helperLineCountY: 3,
                ),
                SizedBox(height: 20),
                LineDiagram.labeled(
                  size: Size(200, 200),
                  gridAxisWidth: 5,
                  lines: [
                    [
                      Offset(50, 10),
                      Offset(100, 50),
                      Offset(125, 150),
                      Offset(150, 175),
                      Offset(200, 180),
                    ],
                    [
                      Offset(50, 30),
                      Offset(100, 70),
                      Offset(125, 170),
                      Offset(150, 195),
                      Offset(200, 200),
                    ],
                  ],
                  gridAxisLabelX: 'AAA',
                  gridAxisLabelY: 'AAA',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 32,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                  ),
                  girdAxisSegmentCountX: 5,
                  girdAxisSegmentCountY: 5,
                  labeledSegments: true,
                  labeledLines: true,
                  // animateLines: true,
                  // helperLineCountX: 3,
                  // helperLineCountY: 3,
                ),
                RingDiagram(
                  size: Size(200, 200),
                  segmentWeights: [
                    0.5,
                    0.25,
                    0.25,
                  ],
                  labeledSegments: true,
                ),
                RingDiagram.gradient(
                  size: Size(200, 200),
                  segmentWeights: [
                    0.25,
                    0.25,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
