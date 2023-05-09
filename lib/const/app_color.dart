import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AppColor {
  static final bgGradient = const LinearGradient(
    colors: [],
  );
  static var darkColor = Color.fromARGB(255, 214, 92, 92);
  static final primaryColor = Color(0xff4338CA);
  static final secondaryColor = Color(0xff6D28D9);
  static final accentColor = Color(0xffffffff);
  static void colorPicker({required BuildContext context}) {
    showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: darkColor,
            onColorChanged: (value) {
              darkColor = value;
            },
          ),
          // Use Material color picker:
          //
          // child: MaterialPicker(
          //   pickerColor: pickerColor,
          //   onColorChanged: changeColor,
          //   showLabel: true, // only on portrait mode
          // ),
          //
          // Use Block color picker:
          //
          // child: BlockPicker(
          //   pickerColor: currentColor,
          //   onColorChanged: changeColor,
          // ),
          //
          // child: MultipleChoiceBlockPicker(
          //   pickerColors: currentColors,
          //   onColorsChanged: changeColors,
          // ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      context: context,
    );
  }
}
