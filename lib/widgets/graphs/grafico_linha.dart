import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Consumo do Mês',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16), // Espaçamento entre o título e o gráfico
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            value.toStringAsFixed(1),
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final day = value.toInt();
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            day < 10 ? '0$day' : '$day', // Formata os dias
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      15, // Número de dias
                      (index) => FlSpot(
                          index.toDouble(), _generateConsumptionValue(index)),
                    ),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 5,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.3),
                    ),
                    dotData: FlDotData(show: true), // Mostrar pontos nos dados
                  ),
                  LineChartBarData(
                    spots: List.generate(
                      15, // Número de dias
                      (index) => FlSpot(index.toDouble(),
                          _generateConsumptionValue(14 - index)), // Inverso
                    ),
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 5,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.withOpacity(0.3),
                    ),
                    dotData: FlDotData(show: true), // Mostrar pontos nos dados
                  ),
                ],
                minX: 0,
                maxX: 14, // Ajustado para 15 dias
                minY: 21, // Valor mínimo
                maxY: 45, // Valor máximo
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Função para gerar valores de consumo
  double _generateConsumptionValue(int index) {
    List<double> valores = [
      27.00,
      28.00,
      35.00,
      32.00,
      30.00,
      29.00,
      28.00,
      26.00,
      21.00,
      24.00,
      30.00,
      35.00,
      37.00,
      40.00,
      37.00
    ];
    return valores[index];
  }
}
