import 'package:energy_app/pages/ambientes_page.dart';
import 'package:energy_app/pages/comparativo_page.dart';
import 'package:energy_app/pages/dashboard_page.dart';
import 'package:energy_app/pages/qualidade_page.dart';
import 'package:energy_app/pages/start_page.dart';
import 'package:energy_app/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  final storage =
      const FlutterSecureStorage(); // Instância para armazenamento seguro

  int _selectedIndex = 0;
  String appBarTitle = "Dashboard";

  static List<Widget> _widgetOptions = <Widget>[
    PageDashboard(),
    AmbientesPage(),
    QualidadePage(),
    PageComparativo(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 0) appBarTitle = "Dashboard";
      if (_selectedIndex == 1) appBarTitle = "Ambientes";
      if (_selectedIndex == 2) appBarTitle = "Qualidade";
      if (_selectedIndex == 3) appBarTitle = "Comparativo";
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.sizeOf(context).width > 460;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(114, 187, 57, 1),
        title: Text(
          appBarTitle,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            tooltip: "Sair",
          )
        ],
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
                    children: [Icon(Icons.roofing), Text("Ambientes")],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _onItemTapped(1);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [Icon(Icons.history), Text("Qualidade")],
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
                ListTile(
                    title: const Row(
                      children: [Icon(Icons.logout), Text("Sair")],
                    ),
                    onTap: _logout),
              ],
            ))
          : null,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: isWideScreen
          ? null
          : Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Color.fromRGBO(114, 187, 57, 1),
                primaryColor: Colors.white,
              ),
              child: BottomNavigationBar(
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
                    icon: Icon(Icons.energy_savings_leaf_outlined),
                    label: 'Qualidade',
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

  void _logout() async {
    final UsuarioService usuarioService = UsuarioService();
    await usuarioService.logout().then((onValue) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TelaInicial(),
          ));
    });
  }
}
