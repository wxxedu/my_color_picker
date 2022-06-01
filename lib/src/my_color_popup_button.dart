import 'package:flutter/cupertino.dart';
import 'package:my_color_picker/src/my_color_indicator_box.dart';
import 'package:my_color_picker/src/my_color_picker_menu.dart';
import 'package:my_popup_menu/my_popup_menu.dart';

class MyColorPopupButton extends StatelessWidget {
  const MyColorPopupButton({
    Key? key,
    required this.color,
    required this.isSelected,
    this.onChanged,
    this.onPressed,
  }) : super(key: key);

  final Color color;
  final bool isSelected;
  final ValueChanged<Color?>? onChanged;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MyPopupIconButton(
      isSelected: isSelected,
      icon: MyColorIndicatorBox(currentColor: color),
      onPressed: onPressed,
      menuContent: MyColorPickerMenu(
        onChanged: onChanged,
        currentColor: color,
      ),
    );
  }
}
