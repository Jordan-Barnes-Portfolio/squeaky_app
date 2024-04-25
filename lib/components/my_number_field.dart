import 'package:flutter/material.dart';

class MyNumberField extends StatelessWidget{

  final dynamic controller;
  final String hintText;
  final bool obscureText;
  final String label;

  const MyNumberField({
    super.key, 
    required this.controller, 
    required this.hintText, 
    required this.obscureText,
    required this.label,
    });

  @override
  Widget build(BuildContext context){
    return  Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 15),
      child: TextField(
        onTapOutside: (PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        keyboardType: const TextInputType.numberWithOptions(),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          label: Text(label),
        border: const OutlineInputBorder(),
          hintText: hintText,
        ),
      ),
    );
  }
}