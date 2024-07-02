import 'package:flutter/material.dart';

class MyTextOnChangedField extends StatelessWidget{

  final dynamic controller;
  final String hintText;
  final bool obscureText;
  final String label;
  final void Function(String)? onChangedFunction; // Change the type of onChangedFunction

  const MyTextOnChangedField({
    super.key, 
    required this.controller, 
    required this.hintText, 
    required this.obscureText,
    required this.label,
    required this.onChangedFunction
    });

  @override
  Widget build(BuildContext context){
    return  Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 15),
      child: TextField(
        onTapOutside: (PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: onChangedFunction,
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