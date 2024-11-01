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
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hoje",
                  style: TextStyle(fontFamily: "Roboto", fontSize: 24),
                ),
                Text("25.00 kWh",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                Text(
                  "Semana",
                  style: TextStyle(fontFamily: "Roboto", fontSize: 24),
                ),
                Text("100.00 kWh",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                Text("Mês",
                    style: TextStyle(fontFamily: "Roboto", fontSize: 24)),
                Text("450.00 kWh",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              width: 124,
              height: 124,
              child: Container(color: Colors.red,),
            )
            // Image.asset(
            //   'images/graficos.png',
            //   width: 124,
            //   height: 124,
            // )
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
      child: BarChartDashboard(title: "Consumo p/ Ambiente", data: [
        {"hoje": 75.00, "semana": 90.00, "mes": 150.00}
      ]),
    );

    return Scaffold(
        body: Center(
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [cardResumoConsumo()],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              cardMediaTensao("Tensão Média (V)", "220"),
              cardMediaTensao("Ambientes", "3")
            ],
          ),
          graphBloco
        ],
      ),
    ));
  }
}
