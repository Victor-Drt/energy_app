import 'package:energy_app/models/ambiente.dart';
import 'package:flutter/material.dart';

class AmbientesPage extends StatefulWidget {
  const AmbientesPage({super.key});

  @override
  State<AmbientesPage> createState() => _AmbientesPageState();
}

class _AmbientesPageState extends State<AmbientesPage> {
  Ambiente a1 = Ambiente(
      id: "id_ambiente",
      nome: "Quarto Victor",
      dataCriacao: "2024-10-30",
      qtdDispositivos: 1,
      usuarioId: "id_usuario");

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
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("${ambiente.nome}",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 24,
                      color: Color.fromRGBO(104, 192, 41, 1),
                      fontWeight: FontWeight.bold)),
              SizedBox(
                width: 30,
              ),
              Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmVWmLeIqu-SPm0h8m8PRy0PwxboIa6rOerw&s',
                width: 150,
                height: 150,
              )
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
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Color.fromRGBO(104, 192, 41, 1),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Consumido",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 24,
                              color: Colors.white)),
                      Text("25.00kWh",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.white))
                    ],
                  )),
              SizedBox(
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
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Color.fromRGBO(104, 192, 41, 1),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 120,
                      margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Dispositivos",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 20,
                                  color: Colors.white)),
                          Text("1",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white))
                        ],
                      )))
            ])
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            ambienteContainer(a1),
            ambienteContainer(a1),
            ambienteContainer(a1),
            ambienteContainer(a1)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Color.fromRGBO(104, 192, 41, 1),
        ),
      ),
    );
  }
}
