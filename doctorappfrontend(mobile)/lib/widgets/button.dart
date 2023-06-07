import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final Function callback;
  final String buttonLabel;
  const Button({super.key, required this.callback, required this.buttonLabel});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => widget.callback(), 
      child: Text(widget.buttonLabel));
  }
}