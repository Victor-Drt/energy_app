import 'package:energy_app/widgets/graphs/grafico_barra.dart';
import 'package:energy_app/widgets/graphs/grafico_linha.dart';
import 'package:energy_app/widgets/graphs/grafico_pizza.dart';
import 'package:flutter/material.dart';

class DeprecatedPage extends StatelessWidget {
  const DeprecatedPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: 
          // BarChartSample(),
          // LineChartSample()
          PieChartSample()
        ),
      
    );
  }
}