import 'package:flutter/material.dart';

class PageDashboard extends StatefulWidget {
  const PageDashboard({super.key});

  @override
  State<PageDashboard> createState() => _PageDashboardState();
}

class _PageDashboardState extends State<PageDashboard> {
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _abrirDataPicker() {
      print("clicou");
    }

    var src =
        'https://www.researchgate.net/publication/353229155/figure/fig5/AS:1045367542013953@1626246452084/The-line-graph-of-electrical-energy-consumption-kWh.png';
    var src2 =
        "https://learn.microsoft.com/pt-br/sql/reporting-services/media/report-builder-pie-chart-preview-percents.png?view=sql-server-ver16";
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      padding: const EdgeInsets.fromLTRB(6, 16, 6, 0),
                      decoration: const BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Image.network(src),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 40, 0, 30),
                      height: 64,
                      width: 305,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(239, 249, 244, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(75))),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Hoje", style: TextStyle(fontSize: 12)),
                              Text("Semana", style: TextStyle(fontSize: 12)),
                              Text("Mensal", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "18.00kW/h",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "32.00kW/h",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "60.00kW/h",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      padding: const EdgeInsets.fromLTRB(6, 16, 6, 6),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(239, 249, 244, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(children: [
                        TextField(
                          controller: _dateController,
                          decoration: const InputDecoration(
                            labelText: 'Data',
                            filled: true,
                            prefixIcon: Icon(Icons.calendar_today),
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                          ),
                          readOnly: true,
                          onTap: () => {_selectDate()},
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.vertical(top: Radius.circular(20))),
                          child: Image.network(
                            src2,
                            fit: BoxFit.fitWidth,
                          ),
                        )
                      ]),
                    )
                  ]),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
