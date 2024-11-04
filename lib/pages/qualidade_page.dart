import 'package:energy_app/widgets/itens/qualidadeCard.dart';
import 'package:flutter/material.dart';

class QualidadePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0, // Espaço horizontal entre os cards
          runSpacing: 8.0, // Espaço vertical entre os cards
          children: [
            // Card que ocupa a linha inteira
            SizedBox(
              width: double.infinity, // Ocupar a largura total
              child: Qualidadecard(
                title: 'Fator de Potência',
                value: '0.95',
              ),
            ),
            // Outros cards que podem ser agrupados
            Qualidadecard(
              title: 'Flutuação Tensão Mínima',
              value: '220V',
            ),
            Qualidadecard(
              title: 'Flutuação Tensão Máxima',
              value: '240V',
            ),
            Qualidadecard(
              title: 'THD Tensão',
              value: '5%',
            ),
            Qualidadecard(
              title: 'THD Corrente',
              value: '3%',
            ),
            Qualidadecard(
              title: 'Oscilação Tensão',
              value: '10V',
            ),
            Qualidadecard(
              title: 'Potência Ativa Média',
              value: '1200 W',
            ),
            // Card que ocupa a linha inteira
            SizedBox(
              width: double.infinity, // Ocupar a largura total
              child: Qualidadecard(
                title: 'Consumo Total Acumulado',
                value: '1500 kWh',
              ),
            ),
          ],
        ),
      ),
    );
  }

}
