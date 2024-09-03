import 'package:energy_app/models/dispositivo.dart';
import 'package:energy_app/pages/historico_page.dart';
import 'package:energy_app/services/dispositivo_service.dart';
import 'package:energy_app/widgets/item_dispositivo.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

List<String> list = <String>['Bloco-01', 'Bloco-02', 'Bloco-03', 'Bloco-04'];

class DispositivosPage extends StatefulWidget {
  const DispositivosPage({super.key});

  @override
  State<DispositivosPage> createState() => _DispositivosPageState();
}

class _DispositivosPageState extends State<DispositivosPage> {
  late Future<List<Dispositivo>> _dispositivosData;
  List<Dispositivo> itensDispositivo = [];
  List<Dispositivo> itensDispositivoFiltrado = [];
  String dropdownValue = list.first;

  @override
  void initState() {
    super.initState();
    final dispositivoService = DispositivoService();
    _dispositivosData = dispositivoService.fetchDispositivo().then((data) {
      setState(() {
        itensDispositivo = data;
        itensDispositivoFiltrado = data;
      });
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
                itensDispositivoFiltrado = itensDispositivo
                    .where((e) =>
                        e.blocoId.toString() ==
                        dropdownValue.substring(dropdownValue.length - 1))
                    .toList();
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
           itensDispositivo.isNotEmpty ? Expanded(
              child:GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(itensDispositivo.length, (index) {
                    return Center(
                        child: ItemDispositivo(
                            dispositivo: itensDispositivo[index],
                            quandoClicar: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PageHistorico()),
                                )));
                  }))) : const CircularProgressIndicator()
        ],
      ),
    );
  }
}
