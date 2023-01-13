import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_doubled_colorpicker/src/utils.dart';

/// Painter for hue color wheel.
class HUEColorWheelPainter extends CustomPainter {
  const HUEColorWheelPainter(this.hsvColor, {this.pointerColor});

  final HSVColor hsvColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radio = size.width <= size.height ? size.width / 2 : size.height / 2;

    final List<Color> colors = [
      const HSVColor.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
    ];
    final Gradient gradientS = SweepGradient(colors: colors);
    const Gradient gradientR = RadialGradient(
      colors: [
        Colors.white,
        Color(0x00FFFFFF),
      ],
    );
    canvas.drawCircle(center, radio, Paint()..shader = gradientS.createShader(rect));
    canvas.drawCircle(center, radio, Paint()..shader = gradientR.createShader(rect));
    //canvas.drawCircle(center, radio, Paint()..color = Colors.black.withOpacity(1 - hsvColor.value));

    final pickOffset = Offset(
      center.dx + hsvColor.saturation * radio * cos((hsvColor.hue * pi / 180)),
      center.dy - hsvColor.saturation * radio * sin((hsvColor.hue * pi / 180)),
    );
    final pickHeight = size.height * 0.04;
    canvas.drawCircle(
      pickOffset,
        pickHeight,
      Paint()
        ..color = hsvColor.toColor(),
    );
    canvas.drawCircle(
      pickOffset,
      pickHeight,
      Paint()
        ..color = Colors.white//pointerColor ?? (useWhiteForeground(hsvColor.toColor()) ? Colors.white : Colors.black)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
