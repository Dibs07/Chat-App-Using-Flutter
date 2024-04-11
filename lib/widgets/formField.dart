import 'package:flutter/material.dart';

class Formfield extends StatelessWidget {
  final String hintText;
  final String labelText;
  const Formfield({super.key, required this.hintText, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}
