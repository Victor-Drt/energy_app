import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Picos de Consumo - Setembro',
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
                      interval: 1,
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final day = value.toInt();
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            "S$day", // Formata os dias
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
                      4, // Número de dias
                      (index) => FlSpot(
                          index.toDouble(), _generateConsumptionValue(index)),
                    ),
                    isCurved: false,
                    color: Colors.blue,
                    barWidth: 2,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.3),
                    ),
                    dotData: FlDotData(show: true), // Mostrar pontos nos dados
                  ),
                  LineChartBarData(
                    spots: List.generate(
                      4, // Número de dias
                      (index) => FlSpot(index.toDouble(),
                          _generateConsumptionValue2(index)), // Inverso
                    ),
                    isCurved: false,
                    color: Colors.red,
                    barWidth: 2,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.withOpacity(0.3),
                    ),
                    dotData: FlDotData(show: true), // Mostrar pontos nos dados
                  ),
                ],
                minX: 0,
                maxX: 3, // Ajustado para 15 dias
                minY: 21, // Valor mínimo
                maxY: 45, // Valor máximo
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 15,
                    height: 15,
                    color: Colors.red,
                  ),
                  Text(
                    "Bloco 1",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 15,
                    height: 15,
                    margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    color: Colors.blue,
                  ),
                  Text(
                    "Bloco 2",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  // Função para gerar valores de consumo
  double _generateConsumptionValue2(int index) {
    List<double> valores = [
      32.00,
      27.00,
      35.00,
      28.00,
    ];
    return valores[index];
  }

  double _generateConsumptionValue(int index) {
    List<double> valores = [
      27.00,
      28.00,
      35.00,
      32.00,
    ];
    return valores[index];
  }
}
