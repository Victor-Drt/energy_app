import 'package:energy_app/models/dispositivo.dart';
import 'package:flutter/material.dart';

class ItemDispositivo extends StatelessWidget {
  const ItemDispositivo(
      {super.key, required this.dispositivo, required this.quandoClicar});

  final Dispositivo dispositivo;
  final Function() quandoClicar;

  @override
  Widget build(BuildContext context) {
    final double iconSize = MediaQuery.sizeOf(context).width * 0.2;
    final double horizontalMargin = MediaQuery.sizeOf(context).width * 0.04;
    final double padding = MediaQuery.sizeOf(context).width * 0.04;

    return Container(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 250), // Define limites de largura para o card
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 8),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(239, 249, 244, 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ajusta o tamanho da coluna
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: iconSize,
            child: IconButton(
              onPressed: quandoClicar,
              icon: Icon(
                Icons.memory,
                size: iconSize,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: Text(
              dispositivo.descricao ?? "Dispositivo ${dispositivo.id}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
              maxLines: 2, // Define um limite de linhas
              overflow: TextOverflow.ellipsis, // Aplica reticências em texto longo
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              "ID: ${dispositivo.macAddress}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            dispositivo.status == true ? "Ativo" : "Inativo",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: dispositivo.status == true ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
