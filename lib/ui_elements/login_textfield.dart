
import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  final String labelText;

  LoginTextField({required this.labelText});

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  TextEditingController _controller = TextEditingController();

  // Function to get the current text inside the TextField
  String get currentText => _controller.text;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.blue),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue), // Blue underline
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue), // Blue underline when focused
        ),
      ),
    );
  }
}
