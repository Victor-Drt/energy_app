import 'dart:convert';
import 'package:energy_app/models/consumo.dart';
import 'package:energy_app/models/dispositivo.dart';
import 'package:energy_app/services/consumo_service.dart';
import 'package:energy_app/widgets/data_divider.dart';
import 'package:energy_app/widgets/item_consumo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

// const List<String> list = <String>[
//   'Bloco-01',
//   'Bloco-02',
//   'Bloco-03',
//   'Bloco-04'
// ];

class PageHistorico extends StatefulWidget {
  const PageHistorico(
      {super.key, required this.dispositivos, required this.dispositovId});

  final List<Dispositivo> dispositivos;
  final int dispositovId;

  @override
  State<PageHistorico> createState() => _PageHistoricoState();
}

class _PageHistoricoState extends State<PageHistorico> {
  late Future<List<Consumo>> _consumoData;
  List<Consumo> itensConsumo = [];
  List<Consumo> itensConsumoFiltrada = [];
  String? dropdownValue = null;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final consumoService = ConsumoService();
    _consumoData = consumoService
        .fetchConsumoByDispositivo(widget.dispositovId.toInt())
        .then((data) {
      setState(() {
        itensConsumo = data;
        itensConsumoFiltrada = data;
      });
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<Map<String, dynamic>>> groupedItems = {};
    for (var item in itensConsumo) {
      DateTime mDate = DateTime.parse(item.createdAt!);
      DateTime date = DateTime(mDate.year, mDate.month, mDate.day);
      if (groupedItems[date] == null) {
        groupedItems[date] = [];
      }
      groupedItems[date]!.add(item.toJson());
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(6, 16, 6, 32),
                width: MediaQuery.sizeOf(context).width * 0.8,
                padding: const EdgeInsets.all(6.0),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(239, 249, 244, 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: DropdownButton<String>(
                  alignment: Alignment.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                  hint: Text("Escolha o Disp..."),
                  value: dropdownValue,
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                      if (dropdownValue != null) {
                        var consumoService = ConsumoService();
                        _consumoData = consumoService
                            .fetchConsumoByDispositivo(
                                int.parse(dropdownValue!))
                            .then((data) {
                          setState(() {
                            itensConsumoFiltrada = data;
                            itensConsumo = data;
                          });
                          return data;
                        });
                        itensConsumoFiltrada = itensConsumo
                            .where((e) =>
                                e.dispositivoId.toString() == dropdownValue)
                            .toList();
                      }
                    });
                  },
                  items: widget.dispositivos
                      .map<DropdownMenuItem<String>>((Dispositivo value) {
                    return DropdownMenuItem<String>(
                      value: value.id.toString(),
                      child: Text(value.nome.toString()),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Consumo>>(
                  future: _consumoData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Nenhum dado disponível'));
                    } else {
                      var newFormat = DateFormat("dd-MM-yy");
                      var hourFormat = DateFormat("HH:mm:ss");

                      return GroupedListView<dynamic, String>(
                        elements: itensConsumoFiltrada,
                        groupBy: (element) => newFormat
                            .format(DateTime.parse(element.createdAt ?? '')),
                        groupSeparatorBuilder: (String groupByValue) =>
                            DateDivider(textDate: groupByValue),
                        itemBuilder: (context, dynamic element) => ItemConsumo(
                          element: element,
                          hourFormat: hourFormat,
                        ),
                        groupComparator: (value1, value2) {
                          var dt1 = newFormat.parse(value1);
                          var dt2 = newFormat.parse(value2);
                          return dt1.compareTo(dt2);
                        },
                        useStickyGroupSeparators: true,
                        order: GroupedListOrder.DESC,
                        // footer: const Text("Sem mais logs de consumo."),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
