import 'package:flutter/material.dart';

class ErrorConection extends StatelessWidget {
  const ErrorConection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Houve um problema de conexão. Tente novamente!",
      style: TextStyle(fontSize: 16, color: Colors.grey),
    );
  }
}
