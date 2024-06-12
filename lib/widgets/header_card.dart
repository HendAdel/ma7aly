import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  final String label;
  final String value;
  const HeaderCard(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        color: Color(0xff216de1),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  )),
              Text(value,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 5, 5, 5),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
