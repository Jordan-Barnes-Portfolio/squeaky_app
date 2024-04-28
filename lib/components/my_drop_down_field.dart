import 'package:flutter/material.dart';

class MyDropDownField extends StatelessWidget {
  final dynamic controller;
  final String hintText;
  final bool obscureText;
  final String label;
  final List<String> options;

  const MyDropDownField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.label,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 15),
      child: DropdownButtonFormField<String>(
        onChanged: (value) => controller.text = value!,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
      ),
    );
  }
}