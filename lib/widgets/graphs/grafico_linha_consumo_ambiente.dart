import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class LineChartConsumoAmbiente extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> itensMedicao;

  const LineChartConsumoAmbiente({Key? key, required this.itensMedicao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Converter as medições em uma lista de séries
    List<CartesianSeries<dynamic, dynamic>> series = [];

    itensMedicao.forEach((dispositivo, leituras) {
      List<MedicaoAmbienteGrafico> dados = leituras.map((leitura) {
        return MedicaoAmbienteGrafico(
          hora: DateFormat('HH:mm:ss').parse(leitura['hora']),
          potenciaAtivaKw: leitura['potenciaAtivaKw'],
        );
      }).toList();

      // Adiciona uma série ao gráfico para cada dispositivo
      series.add(LineSeries<MedicaoAmbienteGrafico, DateTime>(
        name: dispositivo, // Nome do dispositivo como legenda
        dataSource: dados,
        xValueMapper: (MedicaoAmbienteGrafico medicao, _) => medicao.hora,
        yValueMapper: (MedicaoAmbienteGrafico medicao, _) => medicao.potenciaAtivaKw,
      ));
    });

    return SfCartesianChart(
      title: ChartTitle(text: 'Consumo de Energia por Dispositivo'),
      legend: Legend(isVisible: true),
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.Hm(), // Formata o eixo X para horas
        intervalType: DateTimeIntervalType.minutes,
        interval: 1,
      ),
      primaryYAxis: NumericAxis(title: AxisTitle(text: 'Potência Ativa (kW)')),
      series: series, // Usa a lista corrigida aqui
    );
  }
}

// Modelo de dados para a medição do ambiente
class MedicaoAmbienteGrafico {
  final DateTime hora;
  final double potenciaAtivaKw;

  MedicaoAmbienteGrafico({
    required this.hora,
    required this.potenciaAtivaKw,
  });
}
