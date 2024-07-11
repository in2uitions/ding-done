import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final String text;
  final bool active;
  final Function(String) action;

  CircleButton({
    required this.text,
    required this.active,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => action(text),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: active ? Colors.blue : Colors.transparent,
          border: Border.all(color: Colors.blue, width: 2.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
