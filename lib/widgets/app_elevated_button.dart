import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;

  const AppElevatedButton({required this.label, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          fixedSize: const Size(double.maxFinite, 60),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white),
      child: Text(
        label,
      ),
    );
  }
}
