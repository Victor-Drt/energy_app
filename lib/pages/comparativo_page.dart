// ignore_for_file: unused_local_variable

import 'package:energy_app/models/byhora/consumo_hora.dart';
import 'package:energy_app/models/byhora/fatorpotencia_hora.dart';
import 'package:energy_app/models/byhora/potenciareativa_hora.dart';
import 'package:energy_app/models/byhora/tensao_hora.dart';
import 'package:energy_app/services/comparativo_service.dart';
import 'package:energy_app/widgets/graphs/comparativo/grafico_linha_consumo.dart';
import 'package:energy_app/widgets/graphs/comparativo/grafico_linha_fatorpt.dart';
import 'package:energy_app/widgets/graphs/comparativo/grafico_linha_tensao.dart';
import 'package:energy_app/widgets/graphs/comparativo/grafico_linhaptreativa.dart';
import 'package:energy_app/widgets/graphs/grafico_barra.dart';
import 'package:energy_app/widgets/graphs/grafico_pizza.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PageComparativo extends StatefulWidget {
  const PageComparativo({super.key});

  @override
  State<PageComparativo> createState() => _PageComparativoState();
}

class _PageComparativoState extends State<PageComparativo> {
  DateTime? dataSelecionada = DateTime.now();
  late Future<List<ConsumoHora>> _consumoData;
  late Future<List<TensaoHora>> _tensaoData;
  late Future<List<PotenciaReativaHora>> _ptReativaData;
  late Future<List<FatorPTHora>> _fatorPtData;

  List<ConsumoHora> itensConsumoHora = [];
  List<TensaoHora> itensTensaoHora = [];
  List<PotenciaReativaHora> itensPtReativaHora = [];
  List<FatorPTHora> itensFatorPtHora = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarGraficos(dataSelecionada);
  }

  void _carregarGraficos(DateTime? selectedDate) {
    final comparativoService = ComparativoService();
    DateFormat formatDateRequisition = DateFormat('yyyy-MM-dd');

    try {
      _consumoData = comparativoService
          .obterConsumoDia(dia: formatDateRequisition.format(selectedDate!))
          .then((data) {
        setState(() {
          itensConsumoHora = data;
        });
        return data;
      });

      _tensaoData = comparativoService
          .obterTensaoDia(dia: formatDateRequisition.format(selectedDate))
          .then((data) {
        setState(() {
          itensTensaoHora = data;
        });
        return data;
      });

      _ptReativaData = comparativoService
          .obterPtReativaDia(dia: formatDateRequisition.format(selectedDate))
          .then((data) {
        setState(() {
          itensPtReativaHora = data;
        });
        return data;
      });

      _fatorPtData = comparativoService
          .obterFatorPotenciaDia(
              dia: formatDateRequisition.format(selectedDate))
          .then((data) {
        setState(() {
          itensFatorPtHora = data;
          isLoading = false;
        });
        return data;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      return;
    }
  }

  void _incrementDay() {
    setState(() {
      DateTime dataAtual = dataSelecionada!;
      DateTime dataNova = dataAtual.add(Duration(days: 1));

      if (dataNova.month != dataAtual.month) {
        dataNova = DateTime(dataNova.year, dataNova.month, 1);
      }
      dataSelecionada = dataNova;
      _carregarGraficos(dataSelecionada);
    });
  }

  void _decrementDay() {
    setState(() {
      DateTime dataAtual = dataSelecionada!;
      DateTime dataNova = dataAtual.subtract(Duration(days: 1));

      if (dataNova.month != dataAtual.month) {
        int ultimoDiaDoMesAnterior =
            DateTime(dataNova.year, dataNova.month, 0).day;
        dataNova =
            DateTime(dataNova.year, dataNova.month, ultimoDiaDoMesAnterior);
      }
      dataSelecionada = dataNova;
      _carregarGraficos(dataSelecionada);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isEmptyConsumo = itensConsumoHora.isEmpty;

    Text msgSemDados = const Text(
      "Sem dados registrados",
      textAlign: TextAlign.center,
    );

    Container graphConsumoHora = Container(
      width: MediaQuery.sizeOf(context).width * 0.90,
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(239, 249, 244, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: isEmptyConsumo
          ? msgSemDados
          : LineChartConsumoHora(
              itensConsumoHora: itensConsumoHora,
            ),
    );

    Container graphTensaoHora = Container(
      width: MediaQuery.sizeOf(context).width * 0.90,
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(239, 249, 244, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: isEmptyConsumo
          ? msgSemDados
          : LineChartTensaoHora(
              itensTensaoHora: itensTensaoHora,
            ),
    );

    Container grapPotenciaReativaHora = Container(
      width: MediaQuery.sizeOf(context).width * 0.90,
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(239, 249, 244, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: isEmptyConsumo
          ? msgSemDados
          : LineChartPtReativaHora(
              itensPtReativaHora: itensPtReativaHora,
            ),
    );

    Container grapFatorPtHora = Container(
      width: MediaQuery.sizeOf(context).width * 0.90,
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(239, 249, 244, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: isEmptyConsumo
          ? msgSemDados
          : LineChartFatorPtHora(
              itensFatorPt: itensFatorPtHora,
            ),
    );

    Container periodoDados = Container(
        alignment: Alignment.center,
        width: MediaQuery.sizeOf(context).width * 0.90,
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        padding: const EdgeInsets.fromLTRB(6, 16, 6, 6),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(239, 249, 244, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: _decrementDay, icon: const Icon(Icons.arrow_back)),
            Text(
              "${dataSelecionada!.day < 10 ? "0${dataSelecionada!.day}" : "${dataSelecionada!.day}"}/${dataSelecionada!.month < 10 ? "0${dataSelecionada!.month}" : "${dataSelecionada!.month}"}/${dataSelecionada!.year}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: _incrementDay, icon: const Icon(Icons.arrow_forward))
          ],
        ));

    return Scaffold(
      body: Center(
          child: !isLoading
              ? ListView(
                  children: [
                    periodoDados,
                    graphConsumoHora,
                    graphTensaoHora,
                    grapPotenciaReativaHora,
                    grapFatorPtHora
                  ],
                )
              : const CircularProgressIndicator()),
    );
  }
}
