import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.widthFactor = 0.8,
    this.label,
    this.hint,
    this.validator,
    this.obscureText = false,
  });

  final double widthFactor;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width * widthFactor,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
        validator: validator,
        obscureText: obscureText,
      ),
    );
  }
}
