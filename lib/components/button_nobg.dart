import 'package:flutter/material.dart';

class ButtonNoBackground extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const ButtonNoBackground({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff4338CA);
    return OutlinedButton(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          alignment: Alignment.center,
          side: MaterialStateProperty.all(
              const BorderSide(width: 1, color: primaryColor)),
          padding: MaterialStateProperty.all(
              const EdgeInsets.only(right: 35, left: 35, top: 15, bottom: 15)),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)))),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: primaryColor, fontSize: 16),
      ),
    );
  }
}
