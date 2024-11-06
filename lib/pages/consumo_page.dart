import 'dart:math';

import 'package:energy_app/models/medicaoAmbiente.dart';
import 'package:energy_app/services/medicao_service.dart';
import 'package:energy_app/widgets/graphs/grafico_linha_consumo_ambiente.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsumoPage extends StatefulWidget {
  final String ambienteId;

  const ConsumoPage({super.key, required this.ambienteId});

  @override
  State<ConsumoPage> createState() => _ConsumoPageState();
}

class _ConsumoPageState extends State<ConsumoPage> {
  late MedicaoAmbiente? _medicaoData; // Mudança para usar MedicaoAmbiente
  Map<String, List<Map<String, dynamic>>> itensMedicao = {};
  bool isLoading = true;

  // DatePicker
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  DateFormat formattedDate = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _carregarMedicao(widget.ambienteId);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        endDate = picked;
      });
    }
  }

  void _carregarMedicao(String ambienteId) {
    final medicaoService = MedicaoService();
    setState(() {
      isLoading = true;
    });

    medicaoService
        .listarMedicoesPorAmbiente(
      ambienteId: ambienteId,
      startDate: startDate,
      endDate: endDate,
    )
        .then((data) {
      setState(() {
        _medicaoData = data;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false; // Finaliza o carregamento em caso de erro
      });
      print('Erro ao carregar medições: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Consumo do Ambiente",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(114, 187, 57, 1),
      ),
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Dia:'),
                        ElevatedButton(
                          onPressed: () => _selectStartDate(context),
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.zero, // Define bordas retas
                            ),
                          ),
                          child: Text('${formattedDate.format(startDate!)}'),
                        ),
                        IconButton(
                            onPressed: () =>
                                _carregarMedicao(widget.ambienteId),
                            icon: Icon(Icons.search))
                      ],
                    ),
                    _medicaoData!.devices!.first.registrosConsumo!.isNotEmpty
                        ? Container(
                            child: Column(
                              children: [
                                LineChartConsumoAmbiente(
                                  medicaoData: _medicaoData,
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  "Indicadores de Consumo",
                                  style: TextStyle(fontSize: 30),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    cardTotalConsumo(_medicaoData,
                                        "Consumo Total do Dia", Colors.green),
                                    cardMaiorCarga(_medicaoData,
                                        "Maior Carga do Dia", Colors.orange),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    cardMediaConsumo(_medicaoData,
                                        "Consumo Médio do Dia", Colors.green),
                                    cardMenorCarga(_medicaoData,
                                        "Menor Carga do Dia", Colors.orange),
                                  ],
                                )
                              ],
                            ),
                          )
                        : Text("Sem dados coletados neste dia.")
                  ],
                )),
    );
  }

  Widget cardTotalConsumo(
      MedicaoAmbiente? _medicaoData, String title, Color cor) {
    List<RegistrosConsumo>? listaRegistrosConsumo =
        _medicaoData?.devices?[0].registrosConsumo;

    double totalConsumo = calcularConsumoTotal(listaRegistrosConsumo!);

    return Container(
      alignment: Alignment.center,
      // width: MediaQuery.sizeOf(context).width * 0.2,
      height: MediaQuery.sizeOf(context).height * 0.1,
      margin: const EdgeInsets.fromLTRB(6, 12, 6, 12),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ], color: cor, borderRadius: BorderRadius.all(Radius.circular(10))),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "${totalConsumo.toStringAsFixed(3)} kWh",
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget cardMediaConsumo(
      MedicaoAmbiente? _medicaoData, String title, Color cor) {
    List<RegistrosConsumo>? listaRegistrosConsumo =
        _medicaoData!.devices?[0].registrosConsumo;

    double mediaConsumo = calcularMediaTotal(listaRegistrosConsumo!);

    return Container(
      alignment: Alignment.center,
      // width: MediaQuery.sizeOf(context).width * 0.2,
      height: MediaQuery.sizeOf(context).height * 0.1,
      margin: const EdgeInsets.fromLTRB(6, 12, 6, 12),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ], color: cor, borderRadius: BorderRadius.all(Radius.circular(10))),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "${mediaConsumo.toStringAsFixed(3)} kWh",
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget cardMaiorCarga(
      MedicaoAmbiente? _medicaoData, String title, Color cor) {
    List<RegistrosConsumo>? listaRegistrosConsumo =
        _medicaoData!.devices?[0].registrosConsumo;

    double maiorCarga = getMaiorCarga(listaRegistrosConsumo!);

    return Container(
      alignment: Alignment.center,
      // width: MediaQuery.sizeOf(context).width * 0.2,
      height: MediaQuery.sizeOf(context).height * 0.1,
      margin: const EdgeInsets.fromLTRB(6, 12, 6, 12),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ], color: cor, borderRadius: BorderRadius.all(Radius.circular(10))),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "${maiorCarga.toStringAsFixed(3)} kW",
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget cardMenorCarga(
      MedicaoAmbiente? _medicaoData, String title, Color cor) {
    List<RegistrosConsumo>? listaRegistrosConsumo =
        _medicaoData!.devices?[0].registrosConsumo;

    double menorCarga = getMenorCarga(listaRegistrosConsumo!);

    return Container(
      alignment: Alignment.center,
      // width: MediaQuery.sizeOf(context).width * 0.2,
      height: MediaQuery.sizeOf(context).height * 0.1,
      margin: const EdgeInsets.fromLTRB(6, 12, 6, 12),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ], color: cor, borderRadius: BorderRadius.all(Radius.circular(10))),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "${menorCarga.toStringAsFixed(3)} kW",
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }

  double getMaiorCarga(List<RegistrosConsumo> registros) {
    if (registros.isEmpty) return 0.0;

    return registros.fold<double>(
      registros.first.potenciaAtivaKw ?? 0.0,
      (maior, registro) => max(maior, registro.potenciaAtivaKw ?? 0.0),
    );
  }

  double getMenorCarga(List<RegistrosConsumo> registros) {
    if (registros.isEmpty) return 0.0;

    return registros.fold<double>(
      registros.first.potenciaAtivaKw ?? 0.0,
      (maior, registro) => min(maior, registro.potenciaAtivaKw ?? 0.0),
    );
  }

  double calcularConsumoTotal(List<RegistrosConsumo> registros) {
    double total = 0.0;

    for (var registro in registros) {
      total += registro.potenciaAtivaKw!;
    }
    return total;
  }

  double calcularMediaTotal(List<RegistrosConsumo> registros) {
    double total = calcularConsumoTotal(registros);

    double media = total / registros.length;

    return media;
  }
}
