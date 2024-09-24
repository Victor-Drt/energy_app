import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartComparativo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Consumo Total por Bloco",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16), // Espaçamento entre o título e o gráfico
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 800,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            value.toString(),
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        );
                        switch (value.toInt()) {
                          case 0:
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text('Bloco 1', style: style),
                            );
                          case 1:
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text('Bloco 2', style: style),
                            );
                          case 2:
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text('Bloco 3', style: style),
                            );
                          default:
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(''),
                            );
                        }
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(
                        toY: 476.67, // Definir o valor do toY
                        color: Colors.blue,
                        width: 50,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.zero)),
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(
                        toY: 596.67, // Definir o valor do toY
                        color: Colors.green,
                        width: 50, // Ajuste a largura da barra aqui
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.zero)),
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(
                        toY: 703.33, // Definir o valor do toY
                        color: Colors.orange,
                        width: 50,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.zero)),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
