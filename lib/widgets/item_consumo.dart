import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemConsumo extends StatelessWidget {
  final dynamic element;
  final DateFormat hourFormat;

  const ItemConsumo({super.key, this.element, required this.hourFormat});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.redAccent,
      margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(239, 249, 244, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: ListTile(
        title: Text('Consumo: ${element.valor} kW', style: TextStyle(fontWeight: FontWeight.bold),),
        subtitle: Text(
            'Horario: ${hourFormat.format(DateTime.parse(element.createdAt))}'),
      ),
    );
  }
}
