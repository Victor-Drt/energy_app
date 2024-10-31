import 'package:energy_app/pages/ambientes_page.dart';
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
  Color corPrincipal = Colors.white;

  int _selectedIndex = 0;
  String appBarTitle = "Dashboard";

  static List<Widget> _widgetOptions = <Widget>[
    PageDashboard(),
    AmbientesPage(),
    DispositivosPage(),
    PageComparativo(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 0) appBarTitle = "Dashboard";
      if (_selectedIndex == 1) appBarTitle = "Ambientes";
      if (_selectedIndex == 2) appBarTitle = "Dispositivos";
      if (_selectedIndex == 3) appBarTitle = "Comparativo";
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.sizeOf(context).width > 460;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(114, 187, 57, 1),
        title: Text(appBarTitle, style: TextStyle(color: Colors.white),),
        leading: isWideScreen
            ? Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              )
            : null,
      ),
      drawer: isWideScreen
          ? Drawer(
              child: Column(
              children: [
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.bar_chart_outlined),
                      Text("Dashboard")
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _onItemTapped(0);
                  },
                ),
                                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.roofing),
                      Text("Ambientes")
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _onItemTapped(1);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [Icon(Icons.history), Text("Dispositivos")],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _onItemTapped(2);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.compare_arrows_outlined),
                      Text("Comparativo")
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _onItemTapped(3);
                  },
                ),
              ],
            ))
          : null,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: isWideScreen
          ? null
          : Theme(data: Theme.of(context).copyWith(
            canvasColor: Color.fromRGBO(114, 187, 57, 1),
            primaryColor: Colors.white,
          ), child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.roofing),
                  label: 'Ambientes',
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
              unselectedItemColor: Colors.white,
              onTap: _onItemTapped,
            )),
    );
  }
}
