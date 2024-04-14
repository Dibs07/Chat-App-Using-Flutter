import 'package:flutter/material.dart';

class Formfield extends StatelessWidget {
  final String hintText;
  final String labelText;
  final RegExp regExp;
  final bool isObscure;
  final void Function(String?) onSaved;

  const Formfield(
      {super.key,
      required this.hintText,
      required this.labelText,
      required this.regExp,
      this.isObscure = false,
      required this.onSaved,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      obscureText: isObscure,
      validator: (value) {
        if (value != null && regExp.hasMatch(value)) {
          return null;
        }
        return "Please enter a valid ${labelText.toLowerCase()}";
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}
