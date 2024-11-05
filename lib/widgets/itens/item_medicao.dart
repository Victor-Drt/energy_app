import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemMedicao extends StatelessWidget {
  final dynamic element;
  final DateFormat hourFormat;

  const ItemMedicao({super.key, required this.element, required this.hourFormat});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(239, 249, 244, 1.0),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListTile(
        title: Text(
          'Potência Ativa: ${element.potenciaAtiva.toStringAsFixed(1)} W',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tensão: ${element.tensao} V'),
            Text('Corrente: ${element.corrente?.toStringAsFixed(1)} A'),
            Text('Potência Reativa: ${element.potenciaReativa?.toStringAsFixed(1)} var'),
            Text('Consumo Acumulado: ${element.consumoAcumulado} kWh'),
            Text('Data: ${DateFormat("dd/MM/yyyy").format(DateTime.parse(element.timestamp))}'),
            Text('Hora: ${hourFormat.format(DateTime.parse(element.timestamp))}'),
          ],
        ),
      ),
    );
  }
}
