import 'dart:math';

import 'package:flutter/material.dart';

import 'utils.dart';

class BasePainter extends CustomPainter {
  Color baseColor;
  int primarySectors;
  Color primaryColor;
  int secondarySectors;
  Color secondaryColor;
  double sliderStrokeWidth;

  Offset center;
  double radius;

  BasePainter({
    @required this.baseColor,
    @required this.primarySectors,
    @required this.primaryColor,
    @required this.secondarySectors,
    @required this.secondaryColor,
    @required this.sliderStrokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint base = _getPaint(color: baseColor);

    center = Offset(size.width / 2, size.height / 2);
    radius = min(size.width / 2, size.height / 2) - sliderStrokeWidth;
    // we need this in the parent to calculate if the user clicks on the circumference

    assert(radius > 0);

    canvas.drawCircle(center, radius, base);

    if (primarySectors > 0) {
      _paintSectors(primarySectors, 8.0, primaryColor, canvas);
    }

    if (secondarySectors > 0) {
      _paintSectors(secondarySectors, 6.0, secondaryColor, canvas);
    }
  }

  void _paintSectors(
      int sectors, double radiusPadding, Color color, Canvas canvas) {
    Paint section = _getPaint(color: color, width: 2.0);

    var endSectors =
        getSectionsCoordinatesInCircle(center, radius + radiusPadding, sectors);
    var initSectors =
        getSectionsCoordinatesInCircle(center, radius - radiusPadding, sectors);
    _paintLines(canvas, initSectors, endSectors, section);
  }

  void _paintLines(
      Canvas canvas, List<Offset> inits, List<Offset> ends, Paint section) {
    assert(inits.length == ends.length && inits.length > 0);

    for (var i = 0; i < inits.length; i++) {
      canvas.drawLine(inits[i], ends[i], section);
    }
  }

  Paint _getPaint({@required Color color, double width, PaintingStyle style}) =>
      Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..style = style ?? PaintingStyle.stroke
        ..strokeWidth = width ?? sliderStrokeWidth;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
