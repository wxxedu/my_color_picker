import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:my_color_picker/my_color_picker.dart';

class MyColorPickerMenu extends StatefulWidget {
  const MyColorPickerMenu({
    Key? key,
    this.fontStyle = const TextStyle(
      fontSize: 17,
    ),
    this.onChanged,
    this.currentColor,
  }) : super(key: key);
  final TextStyle fontStyle;
  final ValueChanged<Color?>? onChanged;
  final Color? currentColor;
  @override
  State<MyColorPickerMenu> createState() => _MyColorPickerMenuState();
}

class _MyColorPickerMenuState extends State<MyColorPickerMenu> {
  late TextEditingController _controller;
  late Color currentColor;
  int currentAlpha = 255;

  @override
  void initState() {
    super.initState();
    currentColor = widget.currentColor ?? Colors.black;
    currentAlpha = currentColor.alpha;
    _controller = TextEditingController(text: currentColor.hex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MyColorIndicatorBox(currentColor: currentColor),
              const SizedBox(width: 10),
              PlatformText(
                "HEX:",
                style: widget.fontStyle,
              ),
              const SizedBox(width: 10),
              PlatformText("#"),
              Flexible(
                child: PlatformTextField(
                  controller: _controller,
                  onChanged: _onHexTextfieldChanged,
                  onSubmitted: _onHexTextfieldSubmitted,
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          buildColorSlider(
            "Red",
            currentValue: currentColor.red,
            zeroColor: currentColor.zeroRed,
            fullColor: currentColor.fullRed,
            onChanged: _onRedChanged,
          ),
          const SizedBox(height: 20),
          buildColorSlider(
            "Green",
            currentValue: currentColor.green,
            zeroColor: currentColor.zeroGreen,
            fullColor: currentColor.fullGreen,
            onChanged: _onGreenChanged,
          ),
          const SizedBox(height: 20),
          buildColorSlider(
            "Blue",
            currentValue: currentColor.blue,
            zeroColor: currentColor.zeroBlue,
            fullColor: currentColor.fullBlue,
            onChanged: _onBlueChanged,
          ),
          const SizedBox(height: 20),
          buildColorSlider(
            "Alpha",
            currentValue: currentAlpha,
            zeroColor: currentColor.withAlpha(0),
            fullColor: currentColor.withAlpha(255),
            onChanged: _onAlphaChanged,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildColorSlider(
    String label, {
    required int currentValue,
    required Color zeroColor,
    required Color fullColor,
    required void Function(int) onChanged,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PlatformText(
              label,
              style: widget.fontStyle,
            ),
            Expanded(child: Container()),
            PlatformText(
              "${(currentValue / 255 * 100).toStringAsFixed(1)}%",
              style: widget.fontStyle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        MyColorSlider(
          width: 180,
          initialValue: currentValue,
          onChanged: onChanged,
          zeroColor: zeroColor,
          fullColor: fullColor,
        ),
      ],
    );
  }

  /// Called when the hex textfield is changed.
  void _onHexTextfieldChanged(String text) {
    setState(() {
      currentColor = ColorX.fromHex(text, alpha: currentAlpha) ?? currentColor;
    });
  }

  void _onHexTextfieldSubmitted(String text) {
    final clr = ColorX.fromHex(text, alpha: currentAlpha);
    setState(() {
      if (clr == null) {
        _controller.text = currentColor.hex;
      } else {
        currentColor = clr;
        _controller.text = currentColor.hex;
      }
    });
  }

  void _onRedChanged(int value) {
    setState(() {
      currentColor = currentColor.withRed(value);
      _controller.text = currentColor.hex;
    });
  }

  void _onGreenChanged(int value) {
    setState(() {
      currentColor = currentColor.withGreen(value);
      _controller.text = currentColor.hex;
    });
  }

  void _onBlueChanged(int value) {
    setState(() {
      currentColor = currentColor.withBlue(value);
      _controller.text = currentColor.hex;
    });
  }

  void _onAlphaChanged(int value) {
    setState(() {
      currentAlpha = value;
      currentColor = currentColor.withAlpha(value);
      _controller.text = currentColor.hex;
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    widget.onChanged?.call(currentColor);
  }
}

extension ColorX on Color {
  /// Returns if the color is light or dark.
  bool get isLight => computeLuminance() > 0.5;

  /// Returns the color in hexadecimal format without alpha channel.
  String get hex => (value & 0x00FFFFFF)
      .toInt()
      .toRadixString(16)
      .padLeft(6, '0')
      .toUpperCase();

  /// Returns the color in hexidecimal format with alpha
  String get hexWithAlpha =>
      value.toInt().toRadixString(16).padLeft(8, '0').toUpperCase();

  /// Returns a [Color] with a given alpha and a given hexidecimal string.
  static Color? fromHex(String hex, {int alpha = 255}) {
    /// strip # if present
    hex = hex.replaceAll(RegExp(r'[^0-9A-F]'), '');
    final tmp = _getSixDigitHexString(hex);
    if (tmp != null) {
      hex = tmp;
    } else {
      return null;
    }
    try {
      int r = int.parse(hex.substring(0, 2), radix: 16);
      int g = int.parse(hex.substring(2, 4), radix: 16);
      int b = int.parse(hex.substring(4, 6), radix: 16);
      return Color.fromARGB(alpha, r, g, b);
    } on FormatException {
      return null;
    }
  }

  // TODO: modify this to support for more natural hex string fillings, maybe consider using OOP

  /// Returns a corrected hex [String] from the raw input [hex] String.
  static String? _getSixDigitHexString(String hex) {
    if (hex.isEmpty) {
      return null;
    } else if (hex.length == 1) {
      hex = hex * 6;
    } else if (hex.length == 2) {
      hex = hex * 3;
    } else if (hex.length == 3) {
      hex = hex * 2; // double the hex digits
    } else if (hex.length == 4 || hex.length == 5) {
      hex = hex.padRight(6, '0');
    } else if (hex.length > 6) {
      // return the last 6 digits
      hex = hex.substring(hex.length - 6);
    }
    return hex;
  }

  Color get zeroRed => Color.fromARGB(255, 0, green, blue);
  Color get zeroGreen => Color.fromARGB(255, red, 0, blue);
  Color get zeroBlue => Color.fromARGB(255, red, green, 0);
  Color get zeroAlpha => Color.fromARGB(0, red, green, blue);

  Color get fullRed => Color.fromARGB(255, 255, green, blue);
  Color get fullGreen => Color.fromARGB(255, red, 255, blue);
  Color get fullBlue => Color.fromARGB(255, red, green, 255);
  Color get fullAlpha => Color.fromARGB(255, red, green, blue);
}
