import 'package:flutter/material.dart';

class GridViewItems extends StatelessWidget {
  final String label;
  final Color color;
  final IconData iconData;
  final void Function()? onTap;

  const GridViewItems(
      {required this.label,
      required this.color,
      required this.iconData,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: color.withOpacity(.2),
              child: Icon(iconData, size: 40, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
