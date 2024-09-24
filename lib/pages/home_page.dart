import 'package:energy_app/pages/comparativo_page.dart';
import 'package:energy_app/pages/dashboard_page.dart';
import 'package:energy_app/pages/dispositivos_page.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    super.key,
    required this.title,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color corPrincipal = const Color.fromRGBO(60, 184, 120, 100);

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    PageDashboard(),
    DispositivosPage(),
    PageComparativo()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.memory),
            label: 'Dispositivos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Comparativo',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: corPrincipal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
