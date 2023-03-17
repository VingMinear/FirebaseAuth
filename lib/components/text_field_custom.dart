import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController inputController;
  final String? hintText;
  final bool? obscureText;
  final Widget? icon;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  final TextInputType? keyboardType;
  const MyTextField({
    Key? key,
    required this.inputController,
    this.hintText,
    this.keyboardType,
    this.obscureText,
    this.icon,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1)),
      ]),
      child: TextFormField(
        controller: inputController,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          suffixIcon: icon,
          filled: true,
          fillColor: Colors.white.withOpacity(0.85),
          hintText: hintText ?? 'Paste Url here..https://......... ',
          hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey.withOpacity(.75), width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey.withOpacity(.75), width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey.withOpacity(.75), width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
    );
  }
}