import 'package:energy_app/models/dispositivo.dart';
import 'package:energy_app/pages/historico_page.dart';
import 'package:energy_app/services/dispositivo_service.dart';
import 'package:energy_app/widgets/messages/error_conection.dart';
import 'package:energy_app/widgets/itens/item_dispositivo.dart';
import 'package:flutter/material.dart';

class DispositivosPage extends StatefulWidget {
  final String ambienteId;

  const DispositivosPage({super.key, required this.ambienteId});

  @override
  State<DispositivosPage> createState() => _DispositivosPageState();
}

class _DispositivosPageState extends State<DispositivosPage> {
  late Future<List<Dispositivo>> _dispositivosData;
  List<Dispositivo> itensDispositivo = [];
  List<Dispositivo> itensDispositivoFiltrado = [];
  String? dropdownValue;
  bool isLoading = true;
  bool showErrorBar = false;
  final dispositivoService = DispositivoService();

  TextStyle estiloTextoDropdown =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  String formatMacAddress(String input) {
    // Remove qualquer caractere que não seja hexadecimal (0-9, a-f, A-F)
    String sanitizedInput = input.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');

    // Adiciona os ":" a cada dois caracteres
    List<String> groups = [];
    for (int i = 0; i < sanitizedInput.length; i += 2) {
      if (i + 2 <= sanitizedInput.length) {
        groups.add(sanitizedInput.substring(i, i + 2));
      } else {
        groups.add(sanitizedInput.substring(i));
      }
    }

    return groups.join(':');
  }

  Future<void> _showCreateDispositivoDialog() async {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController macAddressController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Dispositivo'),
          content: Container(
            width: MediaQuery.sizeOf(context).width * 0.15,
            height: MediaQuery.sizeOf(context).height * 0.15,
            child: Column(
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                  ),
                ),
                TextField(
                  controller: macAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Endereço MAC',
                  ),
                  onChanged: (value) {
                    String formatted = formatMacAddress(value);
                    if (formatted != value) {
                      macAddressController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(
                          offset: formatted.length,
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () async {
                if (nomeController.text.isNotEmpty &
                    nomeController.text.isNotEmpty) {
                  // Criar ambiente
                  Dispositivo novoDispositivo = Dispositivo(
                    ambienteId: widget.ambienteId,
                    descricao: nomeController.text,
                    macAddress: macAddressController.text,
                  );

                  await dispositivoService
                      .cadastrarDispositivo(novoDispositivo);
                  Navigator.of(context).pop();
                  _fetchDispositivos();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchDispositivos(); // Chama a função para buscar dispositivos ao iniciar
  }

  Future<void> _fetchDispositivos() async {
    try {
      final dispositivos =
          await dispositivoService.fetchDispositivo(widget.ambienteId);
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
                                    dispositovId: 
                                        itensDispositivoFiltrado[index].macAddress!,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDispositivoDialog,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Color.fromRGBO(104, 192, 41, 1),
        ),
      ),
    );
  }
}
