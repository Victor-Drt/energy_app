import 'package:energy_app/pages/cadastro_page.dart';
import 'package:energy_app/pages/home_page.dart';
import 'package:energy_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TelaInicial extends StatefulWidget {
  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final storage =
      const FlutterSecureStorage(); // Instância para armazenamento seguro

  @override
  void initState() {
    super.initState();
    _checkToken(); // Verifica o token ao iniciar a página
  }

  Future<void> _checkToken() async {
    String? token;

    // Verifica se a plataforma é web ou não
    if (html.window.localStorage.containsKey('bearerToken')) {
      // Se for web, busca o token no localStorage
      token = html.window.localStorage['bearerToken'];
    } else {
      // Se for dispositivo móvel, usa o FlutterSecureStorage
      token = await storage.read(key: 'bearerToken');
    }

    if (token != null && !JwtDecoder.isExpired(token)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(title: "Dashboard"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromRGBO(114, 136, 68, 1), // Cor de fundo verde
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Monitore seu Consumo e Qualidade de Energia',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.white, // Texto branco para contraste
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 260,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaCadastro(),
                      ));
                },
                child: Text(
                  'Cadastre-se',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            // Color.fromRGBO(104, 192, 41, 1),
            const SizedBox(height: 16),
            SizedBox(
              width: 260,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(104, 192, 41, 1),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                },
                child: Text(
                  'Entrar',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
