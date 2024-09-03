import 'package:energy_app/models/dispositivo.dart';
import 'package:flutter/material.dart';

class ItemDispositivo extends StatelessWidget {
  const ItemDispositivo(
      {super.key, required this.dispositivo, required this.quandoClicar});

  final Dispositivo dispositivo;
  final Function() quandoClicar;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(239, 249, 244, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: quandoClicar,
              icon: Icon(
                Icons.memory,
                size: MediaQuery.sizeOf(context).width * 0.3,
              )),
          Text(dispositivo.nome.toString())
        ],
      ),
    );
  }
}
