import 'dart:convert';
import 'package:energy_app/models/consumo.dart';
import 'package:energy_app/services/consumo_service.dart';
import 'package:energy_app/widgets/data_divider.dart';
import 'package:energy_app/widgets/item_consumo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

const List<String> list = <String>[
  'Bloco-01',
  'Bloco-02',
  'Bloco-03',
  'Bloco-04'
];

class PageHistorico extends StatefulWidget {
  const PageHistorico({super.key});

  @override
  State<PageHistorico> createState() => _PageHistoricoState();
}

class _PageHistoricoState extends State<PageHistorico> {
  late Future<List<Consumo>> _consumoData;
  List<Consumo> itensConsumo = [];
  List<Consumo> itensConsumoFiltrada = [];
  String dropdownValue = list.first;

  @override
  void initState() {
    super.initState();
    final consumoService = ConsumoService();
    _consumoData = consumoService.fetchConsumo().then((data) {
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
              DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                    itensConsumoFiltrada = itensConsumo
                        .where(
                            (e) => e.dispositivoId.toString() == dropdownValue.substring(dropdownValue.length-1))
                        .toList();
                  });
                  print(dropdownValue.substring(dropdownValue.length-1 ));
                  print(itensConsumoFiltrada.length);
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
