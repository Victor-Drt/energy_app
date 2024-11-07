import 'package:energy_app/widgets/graphs/grafico_barra.dart';
import 'package:energy_app/widgets/graphs/grafico_linha.dart';
import 'package:energy_app/widgets/graphs/grafico_pizza.dart';
import 'package:flutter/material.dart';

class DeprecatedPage extends StatelessWidget {
  const DeprecatedPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: 
                      //         Container(
                      //   margin: const EdgeInsets.fromLTRB(6, 16, 6, 32),
                      //   width: MediaQuery.sizeOf(context).width * 0.8,
                      //   padding: const EdgeInsets.all(6.0),
                      //   decoration: const BoxDecoration(
                      //     color: Color.fromRGBO(239, 249, 244, 1.0),
                      //     borderRadius: BorderRadius.all(Radius.circular(20)),
                      //   ),
                      //   child: DropdownButton<String>(
                      //     isExpanded: true,
                      //     alignment: AlignmentDirectional.center,
                      //     style: estiloTextoDropdown,
                      //     hint: Text(
                      //       "Escolha o Bloco",
                      //       textAlign: TextAlign.center,
                      //       style: estiloTextoDropdown,
                      //     ),
                      //     value: dropdownValue,
                      //     icon: const Icon(Icons.filter_alt_outlined),
                      //     onChanged: (String? value) {
                      //       setState(() {
                      //         dropdownValue = value;
                      //         if (dropdownValue != null) {
                      //           // Filtra dispositivos pelo ID do ambiente
                      //           itensDispositivoFiltrado = itensDispositivo
                      //               .where((e) => e.ambienteId == dropdownValue)
                      //               .toList();
                      //         }
                      //       });
                      //     },
                      //     items: blocos
                      //         .map<DropdownMenuItem<String>>((Bloco value) {
                      //       return DropdownMenuItem<String>(
                      //         alignment: Alignment.center,
                      //         value: value.id.toString(),
                      //         child: Text(
                      //           style: TextStyle(
                      //               color: Colors.black,
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.bold),
                      //           value.nome.toString(),
                      //         ),
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),

          // BarChartSample(),
          // LineChartSample()
          PieChartSample()
        ),
      
    );
  }
}