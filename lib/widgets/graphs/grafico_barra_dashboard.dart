import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartDashboard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;

  const BarChartDashboard({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    double hoje = double.parse(data[0]["hoje"].toString());
    double semana = double.parse(data[0]["semana"].toString());
    double mes = double.parse(data[0]["mes"].toString());

    List<double> valores = [hoje, semana, mes];
    valores.sort();
    double maiorValor = valores.last;

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
                maxY: maiorValor,
                barTouchData: BarTouchData(enabled: true),
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
                        switch (value.toInt()) {
                          case 0:
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                  data.first.keys.elementAt(value.toInt()),
                                  style: style),
                            );
                          case 1:
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                  data.first.keys.elementAt(value.toInt()),
                                  style: style),
                            );
                          case 2:
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                  data.first.keys.elementAt(value.toInt()),
                                  style: style),
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
                        toY: data.first["hoje"], // Definir o valor do toY
                        color: Colors.blue,
                        width: MediaQuery.sizeOf(context).width * 0.2,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.zero)),
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(
                        toY: data.first["semana"], // Definir o valor do toY
                        color: Colors.green,
                        width: MediaQuery.sizeOf(context).width * 0.2,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.zero)),
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(
                        toY: data.first["mes"], // Definir o valor do toY
                        color: Colors.orange,
                        width: MediaQuery.sizeOf(context).width * 0.2,
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
