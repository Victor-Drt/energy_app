// ignore_for_file: unused_local_variable

import 'package:energy_app/widgets/graphs/grafico_barra.dart';
import 'package:energy_app/widgets/graphs/grafico_linha.dart';
import 'package:energy_app/widgets/graphs/grafico_pizza.dart';
import 'package:flutter/material.dart';

class PageComparativo extends StatefulWidget {
  const PageComparativo({super.key});

  @override
  State<PageComparativo> createState() => _PageComparativoState();
}

class _PageComparativoState extends State<PageComparativo> {
  int mes = DateTime.now().month;
  int ano = DateTime.now().year;

  void _incrementMonth() {
    setState(() {
      if (mes == 12) {
        ano += 1;
        mes = 1;
      } else {
        mes += 1;
      }
    });
  }

  void _decrementMonth() {
    setState(() {
      if (mes == 1) {
        ano -= 1;
        mes = 12;
      } else {
        mes -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Container graphLinha = Container(
      width: MediaQuery.sizeOf(context).width * 0.90,
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(239, 249, 244, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: LineChartSample(),
    );

    Container graphLinha2 = Container(
      width: MediaQuery.sizeOf(context).width * 0.90,
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(239, 249, 244, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: LineChartSample(),
    );

    Container graphBloco = Container(
      width: MediaQuery.sizeOf(context).width * 0.90,
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(239, 249, 244, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: BarChartComparativo(),
    );

    Container graphPizza = Container(
      width: MediaQuery.sizeOf(context).width * 0.90,
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(239, 249, 244, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: PieChartSample(),
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
            IconButton(onPressed: _decrementMonth, icon: const Icon(Icons.arrow_back)),
            Text(
              "${mes < 10 ? "0$mes" : mes}/${ano}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: _incrementMonth,
                icon: const Icon(Icons.arrow_forward))
          ],
        ));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comparativo"),
      ),
      body: Center(
          child: ListView(
        children: [periodoDados, graphLinha, graphBloco, graphLinha2],
      )),
    );
  }
}
