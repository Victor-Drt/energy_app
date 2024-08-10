import 'dart:convert';
import 'package:energy_app/models/consumo.dart';
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
  String dropdownValue = list.first;
  late Future<Consumo> consumoFuture;
  List<Consumo> itensConsumo = [];

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
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Expanded(
                  child: FutureBuilder(
                future: fetchConsumo(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var newFormat = DateFormat("dd-MM-yy");
                    var hourFormat = DateFormat("HH:mm:ss");

                    return GroupedListView<dynamic, String>(
                      elements: itensConsumo,
                      groupBy: (element) =>
                          newFormat.format(DateTime.parse(element.createdAt)),
                      groupSeparatorBuilder: (String groupByValue) =>
                          DateDivider(
                        textDate: groupByValue,
                      ),
                      itemBuilder: (context, dynamic element) => ItemConsumo(
                        element: element,
                        hourFormat: hourFormat,
                      ),
                      groupComparator: (value1, value2) {
                        
                        var dt1 = newFormat.parse(value1);
                        var dt2 = newFormat.parse(value2);
                        return dt1.compareTo(dt2);
                      },
                      useStickyGroupSeparators: true, // optional
                      // floatingHeader: true, // optional
                      order: GroupedListOrder.DESC, // optional
                      footer: const Text("Sem mais logs de consumo."), // optional
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Consumo>> fetchConsumo() async {
    String base_url = dotenv.env["api"] ?? "";

    final response = await http
        .get(Uri.parse('${base_url}consumos/'));

    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        itensConsumo.add(Consumo.fromJson(index));
      }
      return itensConsumo;
    } else {
      throw itensConsumo;
    }
  }
}
