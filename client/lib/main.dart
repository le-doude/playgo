import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:logger/logger.dart';

void main() {
  runApp(PlayGoClientApp());
}

class PlayGoClientApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: PlayGoClientHomePage(title: 'Play Go Server'),
    );
  }
}

class PlayGoClientHomePage extends StatefulWidget {
  PlayGoClientHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _PlayGoClientHomePageState createState() => _PlayGoClientHomePageState();
}

class _PlayGoClientHomePageState extends State<PlayGoClientHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(child: Center(child: BoardControl(19, 19))),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class BoardControl extends StatelessWidget {
  final int columns;
  final int rows;

  BoardControl(this.columns, this.rows);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        backgroundImage(),
        gameGrid(this.columns, this.rows),
      ],
    );
  }

  Widget backgroundImage() {
    return Image(
        image: AssetImage("assets/textures/shinkaya2.jpg"),
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.contain);
  }

  Widget gameGrid(int col, int rws) {
    return Center(
        child: CustomPaint(painter: BoardGrid(col, rws), child: Container()));
  }
}

class BoardGrid extends CustomPainter {
  final int columnCount;
  final int rowCount;

  BoardGrid(this.columnCount, this.rowCount);

  @override
  void paint(Canvas canvas, Size size) {
    double dimension = min(size.height, size.width);
    double margin = dimension * 0.045;
    double rectSize = dimension - (margin * 2);
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.red;
    paint.strokeWidth = 2.0;
    var center = Offset(size.width / 2, size.height / 2);
    var rect =
        Rect.fromCenter(center: center, width: rectSize, height: rectSize);
    var gridLinePaint = Paint();
    gridLinePaint.style = PaintingStyle.fill;
    gridLinePaint.color = Colors.black;
    gridLinePaint.strokeWidth = 2.1;
    gridLinePaint.strokeCap = StrokeCap.square;
    gridLinePaint.isAntiAlias = true;
    drawGrid(rectSize, rect, canvas, gridLinePaint);

  }

  void drawGrid(double rectSize, Rect rect, Canvas canvas, Paint gridLinePaint) {
    var dx = rectSize / (columnCount - 1);
    var dy = rectSize / (rowCount - 1);
    for (var i = 0; i < columnCount; i++) {
      var nx = rect.left + i * dx;
      canvas.drawLine(
          Offset(nx, rect.top), Offset(nx, rect.bottom), gridLinePaint);
    }
    for (var i = 0; i < rowCount; i++) {
      var ny = rect.top + i * dy;
      canvas.drawLine(
          Offset(rect.left, ny), Offset(rect.right, ny), gridLinePaint);
    }
    var tengen = rect.center;
    var x4 = rect.left + 3 * dx;
    var y4 = rect.top + 3 * dy;
    var x15 = rect.right - 3 * dx;
    var y15 = rect.bottom - 3 * dy;
    canvas.drawCircle(Offset(x4,y4), 5.5, gridLinePaint);
    canvas.drawCircle(Offset(x4,tengen.dy), 5.5, gridLinePaint);
    canvas.drawCircle(Offset(x4,y15), 5.5, gridLinePaint);

    canvas.drawCircle(Offset(tengen.dx,y4), 5.5, gridLinePaint);
    canvas.drawCircle(Offset(tengen.dx,tengen.dy), 5.5, gridLinePaint);
    canvas.drawCircle(Offset(tengen.dx,y15), 5.5, gridLinePaint);

    canvas.drawCircle(Offset(x15,y4), 5.5, gridLinePaint);
    canvas.drawCircle(Offset(x15,tengen.dy), 5.5, gridLinePaint);
    canvas.drawCircle(Offset(x15,y15), 5.5, gridLinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
