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
  DateTime? startDate = DateTime(2024, 11, 4);
  DateTime? endDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  DateFormat formattedDate = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _carregarMedicao(widget.ambienteId);
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
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Consumo do Ambiente',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                        height: 16), // Espaçamento entre o título e o gráfico
                    Expanded(
                      child: 
                      // Placeholder(),
                      LineChartConsumoAmbiente(medicaoData: _medicaoData,),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
