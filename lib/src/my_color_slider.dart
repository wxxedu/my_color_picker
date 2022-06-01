import 'package:flutter/material.dart';
import 'package:measure_size/measure_size.dart';

class ColorPickerSlider extends StatefulWidget {
  const ColorPickerSlider({
    Key? key,
    required this.onChanged,
    this.indicatorRadius = 10.0,
    this.sliderCornerRadius = 2.5,
    this.width = 200,
    this.height = 10,
    this.zeroColor = Colors.white,
    this.fullColor = Colors.black,
  }) : super(key: key);
  final Function(int) onChanged;
  final Color zeroColor;
  final Color fullColor;
  final double width;
  final double height;
  final double indicatorRadius;
  final double sliderCornerRadius;

  @override
  State<ColorPickerSlider> createState() => _ColorPickerSliderState();
}

class _ColorPickerSliderState extends State<ColorPickerSlider> {
  double _sliderPosition = 0.0;
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: widget.indicatorRadius, right: widget.indicatorRadius),
      child: Listener(
        behavior: HitTestBehavior.deferToChild,
        onPointerDown: onPointerEvent,
        onPointerMove: onPointerEvent,
        onPointerUp: onPointerEvent,
        child: CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _ColorPickerSliderPainter(
            sliderPosition: _sliderPosition,
            zeroColor: widget.zeroColor,
            fullColor: widget.fullColor,
            indicatorRadius: widget.indicatorRadius,
            cornerRadius: widget.sliderCornerRadius,
          ),
        ),
      ),
    );
  }

  void onPointerEvent(PointerEvent event) {
    int value = (((event.localPosition.dx) / (widget.width)) * 255).round();
    if (value > 255) {
      value = 255;
    } else if (value < 0) {
      value = 0;
    }
    if (value != _value) {
      widget.onChanged(value);
      setState(() {
        _sliderPosition = value * widget.width / 255;
      });
      _value = value;
    }
  }
}

class _ColorPickerSliderPainter extends CustomPainter {
  final double sliderPosition;
  final Color zeroColor;
  final Color fullColor;
  final double indicatorRadius;
  final double cornerRadius;

  const _ColorPickerSliderPainter({
    required this.sliderPosition,
    required this.zeroColor,
    required this.fullColor,
    this.indicatorRadius = 10.0,
    this.cornerRadius = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint bgPainter = Paint()
      ..shader = LinearGradient(colors: [zeroColor, fullColor]).createShader(
        Rect.fromLTWH(0, 0, size.width, 0),
      );
    // draw a rounded rectangle
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width, size.height),
        topLeft: Radius.circular(cornerRadius),
        topRight: Radius.circular(cornerRadius),
        bottomLeft: Radius.circular(cornerRadius),
        bottomRight: Radius.circular(cornerRadius),
      ),
      bgPainter,
    );

    // add a border to the rounded rectangle
    final Paint borderPainter = Paint()
      ..color = ColorX.mix(zeroColor, fullColor, 0.2)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width, size.height),
        topLeft: Radius.circular(cornerRadius),
        topRight: Radius.circular(cornerRadius),
        bottomLeft: Radius.circular(cornerRadius),
        bottomRight: Radius.circular(cornerRadius),
      ),
      borderPainter,
    );

    // draw a circle at the slider position
    final Paint sliderPainter = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(sliderPosition, size.height / 2),
      indicatorRadius,
      sliderPainter,
    );
    canvas.drawCircle(
      Offset(sliderPosition, size.height / 2),
      indicatorRadius,
      borderPainter,
    );

    // draw a circle of radius canvas.size.width / 2 at the slider position with the color of the current color
    final Paint colorPainter = Paint()
      ..color = ColorX.mix(zeroColor, fullColor, sliderPosition / size.width);
    canvas.drawCircle(
      Offset(sliderPosition, size.height / 2),
      size.height / 2,
      colorPainter,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

extension ColorX on Color {
  static Color mix(Color a, Color b, double ratio) {
    return Color.fromARGB(
      (a.alpha * (1 - ratio) + b.alpha * ratio).round(),
      (a.red * (1 - ratio) + b.red * ratio).round(),
      (a.green * (1 - ratio) + b.green * ratio).round(),
      (a.blue * (1 - ratio) + b.blue * ratio).round(),
    );
  }
}
