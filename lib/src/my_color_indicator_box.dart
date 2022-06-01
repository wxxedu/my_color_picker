import 'package:flutter/material.dart';

class MyColorIndicatorBox extends StatelessWidget {
  const MyColorIndicatorBox({
    Key? key,
    required this.currentColor,
    this.outerBorderColor = Colors.black,
    this.innerBorderColor = Colors.white,
    this.diameter = 15,
  }) : super(key: key);

  final Color currentColor;
  final Color outerBorderColor;
  final Color innerBorderColor;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter + 2,
      height: diameter + 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Container(
        width: diameter + 2,
        height: diameter + 2,
        decoration: BoxDecoration(
            color: currentColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 1,
            )),
      ),
    );
  }
}
