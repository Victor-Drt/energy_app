import 'package:flutter/material.dart';

class DateDivider extends StatelessWidget {
  final String textDate;

  const DateDivider({super.key, required this.textDate});

  @override
  Widget build(BuildContext context) {
    String titulo = textDate;
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(217, 236, 217, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            height: 3,
          ),
        ));
  }
}
