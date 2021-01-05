import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';

void main() {
  debugPrintGestureArenaDiagnostics = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage('images/background_morning.png'),
              //   fit: BoxFit.cover,
              // ),
              ),
          child: SleepPage()),
    ));
  }
}

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  final baseColor = Color.fromRGBO(255, 255, 255, 0.3);

  int initTime;
  int endTime;

  int inBedTime;
  int outBedTime;
  int days = 0;

  @override
  void initState() {
    super.initState();
    _shuffle();
  }

  void _shuffle() {
    setState(() {
      initTime = _generateRandomTime();
      endTime = _generateRandomTime();
      inBedTime = initTime;
      outBedTime = endTime;
    });
  }

  void _updateLabels(int init, int end, int laps) {
    print('-------');
    print(init);
    print(end);
    setState(() {
      inBedTime = init;
      outBedTime = end;
      days = laps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'How long did you stay in bed?',
          style: TextStyle(color: Colors.white),
        ),
        SingleCircularSlider(
          24,
          1,
          height: 220.0,
          width: 220.0,
          baseColor: Color.fromRGBO(0, 255, 0, 0.2),
          selectionColors: [Colors.transparent, Colors.teal],
          handlerColor: Colors.green[900],
          onSelectionChange: _updateLabels,
          showRoundedCapInSelection: false,
          showHandlerOutter: false,
          sliderStrokeWidth: 10,
          handlerOutterRadius: 20,
          shouldCountLaps: true,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _formatBedTime('IN THE', inBedTime),
          _formatBedTime('OUT OF', outBedTime),
        ]),
        FlatButton(
          child: Text('S H U F F L E'),
          color: baseColor,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          onPressed: _shuffle,
        ),
      ],
    );
  }

  Widget _formatBedTime(String pre, int time) {
    return Column(
      children: [
        Text(pre, style: TextStyle(color: baseColor)),
        Text('BED AT', style: TextStyle(color: baseColor)),
        Text(
          '${_formatTime(time)}',
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  String _formatDays(int days) {
    return days > 0 ? ' (+$days)' : '';
  }

  String _formatTime(int time) {
    if (time == 0 || time == null) {
      return '00:00';
    }
    var hours = time ~/ 12;
    var minutes = (time % 12) * 5;
    return '$hours:$minutes';
  }

  String _formatIntervalTime(int init, int end) {
    var sleepTime = end > init ? end - init : 288 - init + end;
    var hours = sleepTime ~/ 12;
    var minutes = (sleepTime % 12) * 5;
    return '${hours}h${minutes}m';
  }

  int _generateRandomTime() => Random().nextInt(288);
}
