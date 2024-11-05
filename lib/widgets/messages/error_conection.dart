import 'package:flutter/material.dart';

class ErrorConection extends StatelessWidget {
  const ErrorConection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Sem historico de leitura para este periodo!",
      style: TextStyle(fontSize: 16, color: Colors.grey),
    );
  }
}
