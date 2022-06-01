import 'package:flutter/material.dart';

class ColorPickerSlider extends StatefulWidget {
  const ColorPickerSlider({
    Key? key,
    required this.onChanged,
    this.initialValue = 0,
    this.indicatorRadius = 10.0,
    this.sliderCornerRadius = 2.5,
    this.width = 200,
    this.height = 10,
    this.zeroColor = Colors.white,
    this.fullColor = Colors.black,
    this.borderColor = Colors.grey,
  }) : super(key: key);
  final Function(int) onChanged;
  final Color zeroColor;
  final Color fullColor;
  final Color borderColor;
  final int initialValue;
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
  void initState() {
    super.initState();
    _sliderPosition = widget.initialValue / 255 * widget.width;
  }

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
            borderColor: widget.borderColor,
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
  final Color borderColor;

  const _ColorPickerSliderPainter({
    required this.sliderPosition,
    required this.zeroColor,
    required this.fullColor,
    required this.borderColor,
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
      ..color = borderColor
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
