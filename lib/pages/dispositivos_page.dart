import 'package:energy_app/models/bloco.dart';
import 'package:energy_app/models/dispositivo.dart';
import 'package:energy_app/pages/historico_page.dart';
import 'package:energy_app/services/bloco_service.dart';
import 'package:energy_app/services/dispositivo_service.dart';
import 'package:energy_app/widgets/messages/error_conection.dart';
import 'package:energy_app/widgets/itens/item_dispositivo.dart';
import 'package:flutter/material.dart';

class DispositivosPage extends StatefulWidget {
  const DispositivosPage({super.key});

  @override
  State<DispositivosPage> createState() => _DispositivosPageState();
}

class _DispositivosPageState extends State<DispositivosPage> {
  late Future<List<Dispositivo>> _dispositivosData;
  List<Dispositivo> itensDispositivo = [];
  List<Bloco> blocos = [];
  List<Dispositivo> itensDispositivoFiltrado = [];
  String? dropdownValue;
  bool isLoading = true;
  bool showErrorBar = false;
  final dispositivoService = DispositivoService();

  TextStyle estiloTextoDropdown =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _fetchDispositivos(); // Chama a função para buscar dispositivos ao iniciar
  }

  Future<void> _fetchDispositivos() async {
    try {
      final dispositivos = await dispositivoService.fetchDispositivo();
      setState(() {
        itensDispositivo = dispositivos;
        itensDispositivoFiltrado = dispositivos;
        isLoading = false;
        showErrorBar = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        showErrorBar = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dispositivos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(114, 187, 57, 1),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : showErrorBar
                ? const ErrorConection()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Dropdown de seleção de blocos
                      Container(
                        margin: const EdgeInsets.fromLTRB(6, 16, 6, 32),
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        padding: const EdgeInsets.all(6.0),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(239, 249, 244, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          alignment: AlignmentDirectional.center,
                          style: estiloTextoDropdown,
                          hint: Text(
                            "Escolha o Bloco",
                            textAlign: TextAlign.center,
                            style: estiloTextoDropdown,
                          ),
                          value: dropdownValue,
                          icon: const Icon(Icons.filter_alt_outlined),
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value;
                              if (dropdownValue != null) {
                                // Filtra dispositivos pelo ID do ambiente
                                itensDispositivoFiltrado = itensDispositivo
                                    .where((e) => e.ambienteId == dropdownValue)
                                    .toList();
                              }
                            });
                          },
                          items: blocos
                              .map<DropdownMenuItem<String>>((Bloco value) {
                            return DropdownMenuItem<String>(
                              alignment: Alignment.center,
                              value: value.id.toString(),
                              child: Text(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                value.nome.toString(),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      // Grid de dispositivos
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          children: List.generate(
                              itensDispositivoFiltrado.length, (index) {
                            return ItemDispositivo(
                              dispositivo: itensDispositivoFiltrado[index],
                              quandoClicar: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PageHistorico(
                                    dispositivos: itensDispositivo,
                                    dispositovId: int.parse(
                                        itensDispositivoFiltrado[index].id!),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      if (showErrorBar) const Text("Erro de rede"),
                    ],
                  ),
      ),
    );
  }
}
