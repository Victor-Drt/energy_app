import 'package:energy_app/models/byhora/consumo_hora.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartConsumoHora extends StatelessWidget {
  final List<ConsumoHora> itensConsumoHora;

  LineChartConsumoHora({required this.itensConsumoHora});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Potência Total (kW) por Hora',
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
                            value.toStringAsFixed(1),
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text("(horas)"),
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final hour = value.toInt();
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            '${hour}h',
                            style: TextStyle(fontSize: 8, color: Colors.black),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateSpots(), // Lista de pontos a partir dos dados
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.3),
                    ),
                    dotData: FlDotData(show: true),
                  ),
                ],
                minX: 0,
                maxX: 23, // Horas do dia (0 a 23)
                minY: 0,
                maxY: _getMaxY(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Gera a lista de pontos (FlSpot) com base nos registros
  List<FlSpot> _generateSpots() {
    // Como a lista `itensConsumoHora` pode ter várias entradas, vamos considerar apenas o primeiro elemento.
    if (itensConsumoHora.isEmpty || itensConsumoHora.first.registros == null) {
      return [];
    }

    // Extraindo registros do primeiro item da lista de `ConsumoHora`
    final registros = itensConsumoHora.first.registros!;
    return registros
        .where((registro) => registro.hora != null && registro.potenciaTotalKw != null)
        .map((registro) {
          final hora = int.tryParse(registro.hora!) ?? 0;
          final potencia = registro.potenciaTotalKw!.toStringAsFixed(4);
          return FlSpot(hora.toDouble(), double.parse(potencia));
        })
        .toList();
  }

  /// Obtém o valor mínimo de potência total
  double _getMinY() {
    if (itensConsumoHora.isEmpty || itensConsumoHora.first.registros == null) return 0;

    return itensConsumoHora.first.registros!
        .where((registro) => registro.potenciaTotalKw != null)
        .map((registro) => registro.potenciaTotalKw!)
        .reduce((a, b) => a < b ? a : b);
  }

  /// Obtém o valor máximo de potência total
  double _getMaxY() {
    if (itensConsumoHora.isEmpty || itensConsumoHora.first.registros == null) return 0;

    return itensConsumoHora.first.registros!
        .where((registro) => registro.potenciaTotalKw != null)
        .map((registro) => registro.potenciaTotalKw!)
        .reduce((a, b) => a > b ? a : b);
  }
}
