import 'package:energy_app/models/ambiente.dart';
import 'package:energy_app/models/indicadorDashboard.dart';
import 'package:energy_app/services/ambiente_service.dart';
import 'package:energy_app/services/medicao_service.dart';
import 'package:energy_app/widgets/graphs/grafico_barra_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PageDashboard extends StatefulWidget {
  const PageDashboard({super.key});

  @override
  State<PageDashboard> createState() => _PageDashboardState();
}

class _PageDashboardState extends State<PageDashboard> {
  final ambienteService = AmbienteService();
  final medicaoService = MedicaoService();

  List<Ambiente> itensAmbiente = [];
  IndicadorDashboard? indicadorConsumo;

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
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchIndicadores() async {
    try {
      final data = await medicaoService.obterEstatisticas(
        startDate: startDate,
        endDate: endDate,
      );
      setState(() {
        if (data != null) indicadorConsumo = data;
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchIndicadores();
    _fetchAmbientes(); // Chama a função para buscar ambientes ao iniciar
  }

  @override
  Widget build(BuildContext context) {
    Widget cardResumoConsumo() {
      return Container(
          alignment: Alignment.center,
          width: MediaQuery.sizeOf(context).width * 0.9,
          // height: MediaQuery.sizeOf(context).height * 0.3,
          margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hoje",
                  style: TextStyle(fontFamily: "Roboto", fontSize: 24),
                ),
                Text("${indicadorConsumo?.consumoDiario?.toStringAsPrecision(5)} kW",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                Text(
                  "Semana",
                  style: TextStyle(fontFamily: "Roboto", fontSize: 24),
                ),
                Text("${indicadorConsumo?.consumoMensal?.toStringAsPrecision(5)} kW",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                Text("Mês",
                    style: TextStyle(fontFamily: "Roboto", fontSize: 24)),
                Text("${indicadorConsumo?.consumoMensal?.toStringAsPrecision(5)} kW",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Image.asset(
              'assets/images/graficos.png',
              width: 124,
              height: 124,
            )
          ]));
    }

    Widget cardMediaTensao(String title, String valor) {
      return Container(
        alignment: Alignment.center,
        // width: MediaQuery.sizeOf(context).width * 0.2,
        height: MediaQuery.sizeOf(context).height * 0.2,
        margin: const EdgeInsets.fromLTRB(6, 12, 6, 12),
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            Text("${valor}",
                style: TextStyle(fontFamily: "Roboto", fontSize: 24))
          ],
        ),
      );
    }

    Container graphBloco = Container(
      width: MediaQuery.sizeOf(context).width * 0.90,
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: BarChartDashboard(
          title: "Consumo p/ Ambiente", ambientes: itensAmbiente),
    );

    return Scaffold(
        body: Center(
      child: isLoading
          ? CircularProgressIndicator()
          : ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [cardResumoConsumo()],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    cardMediaTensao("Tensão Média (V)", "${indicadorConsumo?.tensaoMedia?.toStringAsPrecision(4)}"),
                    cardMediaTensao("Ambientes", "${indicadorConsumo?.quantidadeAmbientes}")
                  ],
                ),
                graphBloco
              ],
            ),
    ));
  }
}
