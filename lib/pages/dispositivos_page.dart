import 'package:energy_app/models/bloco.dart';
import 'package:energy_app/models/dispositivo.dart';
import 'package:energy_app/pages/historico_page.dart';
import 'package:energy_app/services/bloco_service.dart';
import 'package:energy_app/services/dispositivo_service.dart';
import 'package:energy_app/widgets/item_dispositivo.dart';
import 'package:flutter/material.dart';

class DispositivosPage extends StatefulWidget {
  const DispositivosPage({super.key});

  @override
  State<DispositivosPage> createState() => _DispositivosPageState();
}

class _DispositivosPageState extends State<DispositivosPage> {
  late Future<List<Dispositivo>> _dispositivosData;
  late Future<List<Bloco>> _blocosData;
  List<Dispositivo> itensDispositivo = [];
  List<Bloco> blocos = [];
  List<Dispositivo> itensDispositivoFiltrado = [];
  String? dropdownValue;
  bool isLoading = true;
  bool showErrorBar = false;

  @override
  void initState() {
    super.initState();
    final dispositivoService = DispositivoService();
    final blocoService = BlocoService();

    try {
      _blocosData = blocoService.fetchBloco().then((b) {
        setState(() {
          blocos = b;
        });
        return b;
      });

      _dispositivosData = dispositivoService.fetchDispositivo().then((data) {
        setState(() {
          itensDispositivo = data;
          itensDispositivoFiltrado = data;
          isLoading = false;
        });
        return data;
      });
    } catch (e) {
      setState(() {
        showErrorBar = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: !isLoading
            ? Column(
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
                      hint: const Text("Escolha o Bloco"),
                      value: dropdownValue,
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                          if (dropdownValue != null) {
                            itensDispositivoFiltrado = itensDispositivo
                                .where((e) =>
                                    e.blocoId.toString() == dropdownValue)
                                .toList();
                          }
                        });
                      },
                      items:
                          blocos.map<DropdownMenuItem<String>>((Bloco value) {
                        return DropdownMenuItem<String>(
                          alignment: Alignment.center,
                          value: value.id.toString(),
                          child: Text(
                            value.nome.toString(),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                      child: GridView.count(
                          crossAxisCount: 2,
                          children: List.generate(
                              itensDispositivoFiltrado.length, (index) {
                            return Center(
                                child: ItemDispositivo(
                                    dispositivo:
                                        itensDispositivoFiltrado[index],
                                    quandoClicar: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PageHistorico(
                                                    dispositivos:
                                                        itensDispositivo,
                                                    dispositovId:
                                                        itensDispositivoFiltrado[
                                                                index]
                                                            .id!
                                                            .toInt(),
                                                  )),
                                        )));
                          }))),
                  if (showErrorBar) Text("Erro de rede")
                ],
              )
            : const CircularProgressIndicator());
            
  }
}
