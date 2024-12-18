import 'package:energy_app/models/ambiente.dart';
import 'package:energy_app/pages/consumo_page.dart';
import 'package:energy_app/pages/dispositivos_page.dart';
import 'package:energy_app/services/ambiente_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AmbientesPage extends StatefulWidget {
  const AmbientesPage({super.key});

  @override
  State<AmbientesPage> createState() => _AmbientesPageState();
}

class _AmbientesPageState extends State<AmbientesPage> {
  final ambienteService = AmbienteService();

  List<Ambiente> itensAmbiente = [];
  List<Ambiente> itensAmbienteFiltrado = [];
  bool isLoading = true;

  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  DateFormat formattedDate = DateFormat('dd/MM/yyyy');

  Future<void> _fetchAmbientes() async {
    try {
      final ambientes = await ambienteService.listarAmbientes(
        startDate: startDate,
        endDate: endDate,
      );
      setState(() {
        itensAmbiente = ambientes;
        itensAmbienteFiltrado = ambientes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showCreateAmbienteDialog() async {
    final TextEditingController nomeController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Criar Ambiente'),
          content: TextField(
            controller: nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome do Ambiente',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: const Text('Criar'),
              onPressed: () async {
                if (nomeController.text.isNotEmpty) {
                  Ambiente novoAmbiente = Ambiente(
                    id: 'id_novo_ambiente', // Você pode gerar um ID único aqui
                    nome: nomeController.text,
                    dataCriacao: DateTime.now().toIso8601String(),
                    qtdDispositivos: 0,
                    usuarioId: 'id_usuario',
                  );

                  await ambienteService.cadastrarAmbiente(novoAmbiente);

                  Navigator.of(context).pop();
                  _fetchAmbientes();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget ambienteContainer(Ambiente ambiente) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.sizeOf(context).width * 0.2,
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "${ambiente.nome}",
              style: const TextStyle(
                fontFamily: "Roboto",
                fontSize: 24,
                color: Color.fromRGBO(104, 192, 41, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 30),
            Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmVWmLeIqu-SPm0h8m8PRy0PwxboIa6rOerw&s',
              width: 150,
              height: 150,
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                alignment: Alignment.center,
                width: 150,
                height: 120,
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: const Color.fromRGBO(104, 192, 41, 1),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ConsumoPage(ambienteId: ambiente.id!)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Consumido",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 24,
                              color: Colors.white)),
                      Text("${ambiente.consumoAcumuladokWh}kW",
                          style: const TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.white))
                    ],
                  ),
                )),
            const SizedBox(
              width: 30,
            ),
            Container(
              alignment: Alignment.center,
              width: 150,
              height: 120,
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: const Color.fromRGBO(104, 192, 41, 1),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: GestureDetector(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DispositivosPage(
                                  ambienteId: ambiente.id.toString(),
                                )),
                      ),
                  child: Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 120,
                      margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Dispositivos",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 20,
                                  color: Colors.white)),
                          Text("${ambiente.qtdDispositivos}",
                              style: const TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white))
                        ],
                      ))),
            )
          ])
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAmbientes(); // Chama a função para buscar ambientes ao iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : itensAmbienteFiltrado.isNotEmpty
                ? ListView.builder(
                    itemCount: itensAmbienteFiltrado.length,
                    itemBuilder: (context, index) {
                      return ambienteContainer(itensAmbienteFiltrado[index]);
                    },
                  )
                : const Text("Você não possui ambientes cadastrados."),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateAmbienteDialog,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Color.fromRGBO(104, 192, 41, 1),
        ),
      ),
    );
  }
}
