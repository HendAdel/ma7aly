import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField(
      {this.controller, this.labelText, this.validator, super.key});

  final TextEditingController? controller;
  final String? labelText;
  final String? Function(String?)? validator;
  InputBorder get textFieldBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: textFieldBorder,
        focusedBorder: textFieldBorder.copyWith(
            borderSide: BorderSide(
          width: 2,
          color: Theme.of(context).primaryColor,
        )),
        enabledBorder: textFieldBorder,
        errorBorder: textFieldBorder.copyWith(
            borderSide: BorderSide(
                width: 2, color: Theme.of(context).colorScheme.error)),
        labelText: labelText,
      ),
      validator: validator,
    );
  }
}
