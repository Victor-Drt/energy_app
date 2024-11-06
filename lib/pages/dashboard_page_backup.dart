import 'package:energy_app/widgets/graphs/grafico_barra.dart';
import 'package:energy_app/widgets/graphs/grafico_barra_dashboard.dart';
import 'package:energy_app/widgets/graphs/grafico_linha_dashboard.dart';
import 'package:energy_app/widgets/graphs/grafico_pizza.dart';
import 'package:flutter/material.dart';

class PageDashboard extends StatefulWidget {
  const PageDashboard({super.key});

  @override
  State<PageDashboard> createState() => _PageDashboardState();
}

class _PageDashboardState extends State<PageDashboard> {

  @override
  Widget build(BuildContext context) {
    // Container graphBloco = Container(
    //   width: MediaQuery.sizeOf(context).width * 0.90,
    //   height: MediaQuery.sizeOf(context).height * 0.40,
    //   margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    //   decoration: const BoxDecoration(
    //       color: Color.fromRGBO(239, 249, 244, 1.0),
    //       borderRadius: BorderRadius.all(Radius.circular(20))),
    //   child: BarChartDashboard(title: "Consumo Total", data: [
    //     {"hoje": 75.00, "semana": 90.00, "mes": 150.00}
    //   ]),
    // );

    // Container graphLinha = Container(
    //   width: MediaQuery.sizeOf(context).width * 0.90,
    //   height: MediaQuery.sizeOf(context).height * 0.40,
    //   margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    //   decoration: const BoxDecoration(
    //       color: Color.fromRGBO(239, 249, 244, 1.0),
    //       borderRadius: BorderRadius.all(Radius.circular(20))),
    //   child: LineChartDashboard(),
    // );

    // Container graphPizza = Container(
    //   width: MediaQuery.sizeOf(context).width * 0.90,
    //   height: MediaQuery.sizeOf(context).height * 0.40,
    //   margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    //   decoration: const BoxDecoration(
    //       color: Color.fromRGBO(239, 249, 244, 1.0),
    //       borderRadius: BorderRadius.all(Radius.circular(20))),
    //   child: PieChartSample(),
    // );

    return Scaffold(
        body: ListView(
          children: [],
        ));
  }
}
