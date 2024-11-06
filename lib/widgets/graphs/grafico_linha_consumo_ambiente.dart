import 'package:energy_app/models/medicaoAmbiente.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class LineChartConsumoAmbiente extends StatelessWidget {
  final MedicaoAmbiente? medicaoData;

  const LineChartConsumoAmbiente({Key? key, required this.medicaoData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verificar se os dados de medição estão disponíveis
    if (medicaoData == null || medicaoData!.devices == null) {
      return Center(child: Text("No data available"));
    }

    // Criar a lista de séries para o gráfico
    List<CartesianSeries<dynamic, dynamic>> series = [];

    // Iterar sobre os dispositivos na lista de dispositivos
    for (var device in medicaoData!.devices!) {
      // Verificar se há registros de consumo
      if (device.registrosConsumo != null) {
        List<MedicaoAmbienteGrafico> dados = device.registrosConsumo!.map((registro) {
          return MedicaoAmbienteGrafico(
            hora: DateTime.parse(registro.hora!),
            potenciaAtivaKw: registro.potenciaAtivaKw!,
          );
        }).toList();

        // Adiciona uma série ao gráfico para cada dispositivo
        series.add(LineSeries<MedicaoAmbienteGrafico, DateTime>(
          name: device.nome, // Nome do dispositivo como legenda
          dataSource: dados,
          xValueMapper: (MedicaoAmbienteGrafico medicao, _) => medicao.hora,
          yValueMapper: (MedicaoAmbienteGrafico medicao, _) => medicao.potenciaAtivaKw,
        ));
      }
    }

    return SfCartesianChart(
      title: ChartTitle(text: 'Consumo de Energia por Dispositivo'),
      legend: Legend(isVisible: true),
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.Hm(), // Formata o eixo X para horas
        intervalType: DateTimeIntervalType.minutes,
        interval: 1,
      ),
      primaryYAxis: NumericAxis(title: AxisTitle(text: 'Potência Ativa (kW)')),
      series: series, // Usa a lista de séries gerada
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
