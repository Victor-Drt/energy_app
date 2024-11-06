import 'package:energy_app/models/ambiente.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartDashboard extends StatelessWidget {
  final String title;
  final List<Ambiente> ambientes;

  const BarChartDashboard({super.key, required this.title, required this.ambientes});

  @override
  Widget build(BuildContext context) {
    // Pegando o valor de consumo acumulado de cada ambiente
    List<double> consumos = ambientes.map((ambiente) {
      return double.parse(ambiente.consumoAcumuladokWh!); // Consumindo o valor acumulado em kWh
    }).toList();

    // Encontrando o maior valor de consumo para definir o valor máximo do eixo Y
    double maiorValor = consumos.isNotEmpty ? consumos.reduce((a, b) => a > b ? a : b) : 0.0;

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
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
                maxY: maiorValor, // Definindo o maior valor no eixo Y
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        );

                        // Exibe o nome de cada ambiente na parte inferior
                        int index = value.toInt();
                        if (index >= 0 && index < ambientes.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              ambientes[index].nome ?? 'Ambiente $index',
                              style: style,
                            ),
                          );
                        } else {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text('Potencia Ativa kW'),
                          );
                        }
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(ambientes.length, (index) {
                  return BarChartGroupData(
                    x: index, // Cada ambiente tem um índice diferente
                    barRods: [
                      BarChartRodData(
                        toY: consumos[index], // Valor de consumo acumulado de cada ambiente
                        color: Colors.blue, // Cor da barra (você pode variar a cor se preferir)
                        width: MediaQuery.sizeOf(context).width * 0.2, // Largura da barra
                        borderRadius: BorderRadius.vertical(bottom: Radius.zero),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
