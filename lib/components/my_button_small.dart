import 'package:flutter/material.dart';

class MyButtonSmall extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const MyButtonSmall({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 230, 35),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Center(
            child: Text(text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ))),
      ),
    );
  }
}
