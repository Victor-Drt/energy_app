import 'package:energy_app/models/medicao.dart';
import 'package:energy_app/models/dispositivo.dart';
import 'package:energy_app/services/medicao_service.dart';
import 'package:energy_app/widgets/itens/data_divider.dart';
import 'package:energy_app/widgets/messages/error_conection.dart';
import 'package:energy_app/widgets/itens/item_medicao.dart'; // Atualize para o widget específico de Medicao
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class PageHistorico extends StatefulWidget {
  const PageHistorico(
      {super.key, required this.dispositivos, required this.dispositovId});

  final List<Dispositivo> dispositivos;
  final String dispositovId;

  @override
  State<PageHistorico> createState() => _PageHistoricoState();
}

class _PageHistoricoState extends State<PageHistorico> {
  late Future<List<Medicao>> _medicaoData;
  List<Medicao> itensMedicao = [];
  List<Medicao> itensMedicaoFiltrada = [];
  String? dropdownValue;
  bool isLoading = true;

  // datepicker
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  DateFormat formattedDate = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _carregarMedicao(widget.dispositovId);
  }

  void _carregarMedicao(String dispositivoId) {
    final medicaoService = MedicaoService();
    DateFormat formatDateRequisition = DateFormat('yyyy-MM-dd');

    _medicaoData = medicaoService
        .listarMedicoes(
            macAddress: dispositivoId.toString(),
            startDate: formatDateRequisition.format(startDate!),
            endDate: formatDateRequisition.format(endDate!))
        .then((data) {
      setState(() {
        itensMedicao = data;
        itensMedicaoFiltrada = data;
        isLoading = false;
      });
      return data;
    });
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
      });

      print(startDate);
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ??
          (startDate ?? DateTime.now()), // Inicializa com a data de início
      firstDate: startDate ??
          DateTime(
              2000), // Garante que a data de fim não seja antes da data de início
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
      print(endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Historico",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(114, 187, 57, 1),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: !isLoading
              ? itensMedicao.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('De:'),
                            ElevatedButton(
                              onPressed: () => _selectStartDate(context),
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.zero, // Define bordas retas
                                ),
                              ),
                              child:
                                  Text('${formattedDate.format(startDate!)}'),
                            ),
                            Text('Até:'),
                            ElevatedButton(
                              onPressed: () => _selectEndDate(context),
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.zero, // Define bordas retas
                                ),
                              ),
                              child: Text('${formattedDate.format(endDate!)}'),
                            ),
                            IconButton(onPressed: () => _carregarMedicao(widget.dispositovId), icon: Icon(Icons.search))
                          ],
                        ),
                        // Container(
                        //   margin: const EdgeInsets.fromLTRB(6, 16, 6, 32),
                        //   width: MediaQuery.sizeOf(context).width * 0.8,
                        //   padding: const EdgeInsets.all(6.0),
                        //   decoration: const BoxDecoration(
                        //       color: Color.fromRGBO(239, 249, 244, 1.0),
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(20))),
                        //   child: DropdownButton<String>(
                        //     isExpanded: true,
                        //     alignment: Alignment.center,
                        //     style: const TextStyle(
                        //         fontSize: 16, fontWeight: FontWeight.bold),
                        //     hint: const Text("Escolha o Dispositivo"),
                        //     value: dropdownValue,
                        //     icon: const Icon(Icons.filter_alt_outlined),
                        //     onChanged: (String? value) {
                        //       setState(() {
                        //         dropdownValue = value;
                        //         if (dropdownValue != null) {
                        //           String dispositivoId = dropdownValue!;
                        //           _carregarMedicao(dispositivoId);
                        //           itensMedicaoFiltrada = itensMedicao
                        //               .where((e) =>
                        //                   e.dispositivoId == dropdownValue)
                        //               .toList();
                        //         }
                        //       });
                        //     },
                        //     items: widget.dispositivos
                        //         .map<DropdownMenuItem<String>>(
                        //             (Dispositivo value) {
                        //       return DropdownMenuItem<String>(
                        //         alignment: Alignment.center,
                        //         value: value.id.toString(),
                        //         child: Text(
                        //           value.descricao ?? "Dispositivo ${value.id}",
                        //           style: const TextStyle(
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.black),
                        //         ),
                        //       );
                        //     }).toList(),
                        //   ),
                        // ),
                        Expanded(
                          child: FutureBuilder<List<Medicao>>(
                            future: _medicaoData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Erro: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('Nenhum dado disponível'));
                              } else {
                                var newFormat = DateFormat("dd-MM-yy");
                                var hourFormat = DateFormat("HH:mm:ss");

                                return GroupedListView<dynamic, String>(
                                  elements: itensMedicaoFiltrada,
                                  groupBy: (element) => newFormat.format(
                                      DateTime.parse(element.timestamp ?? '')),
                                  groupSeparatorBuilder:
                                      (String groupByValue) =>
                                          DateDivider(textDate: groupByValue),
                                  itemBuilder: (context, dynamic element) =>
                                      ItemMedicao(
                                    element: element,
                                    hourFormat: hourFormat,
                                  ),
                                  groupComparator: (value1, value2) {
                                    var dt1 = newFormat.parse(value1);
                                    var dt2 = newFormat.parse(value2);
                                    return dt2.compareTo(dt1);
                                  },
                                  useStickyGroupSeparators: true,
                                  order: GroupedListOrder.DESC,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  : const ErrorConection()
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
