import 'package:flutter/material.dart';

class MySelectorButton extends StatefulWidget {
  final String text;
  final Function()? onPressed;
  final Color color;
  final String index;

  const MySelectorButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.index,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MySelectorButtonState createState() => _MySelectorButtonState();
}

class _MySelectorButtonState extends State<MySelectorButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            isPressed = !isPressed;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: isPressed ? Colors.grey[500] : widget.color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.grey[300],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}