import 'package:energy_app/models/usuario.dart';
import 'package:energy_app/pages/home_page.dart';
import 'package:energy_app/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TelaCadastro extends StatefulWidget {
  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _senhaConfirmController = TextEditingController();

  bool isObscure1 = true;
  bool isObscure2 = true;
  bool _isLoading = false;

  String? _errorMessage;
  final UsuarioService usuarioService = UsuarioService();
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Análise de Qualidade de Energia'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Registre-se para\nMonitorar seu\nconsumo em\ntempo Real',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                  color: Color(0xFF708238), // Cor verde similar à imagem
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      errorText: _errorMessage,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _senhaController,
                    obscureText: isObscure1,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      errorText: _errorMessage,
                      suffixIcon: IconButton(
                        icon: isObscure1
                            ? Icon(Icons.remove_red_eye_outlined)
                            : Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            isObscure1 = !isObscure1;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _senhaConfirmController,
                    obscureText: isObscure2,
                    onChanged: (value) {
                      setState(() {
                        value.isEmpty || value != _senhaController.text
                            ? _errorMessage = "Senhas não conferem"
                            : _errorMessage = null;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Confirmar senha',
                      errorText: _errorMessage,
                      suffixIcon: IconButton(
                        icon: isObscure2
                            ? Icon(Icons.remove_red_eye_outlined)
                            : Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            isObscure2 = !isObscure2;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(104, 192, 41, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    onPressed: _isLoading ? null : _register,
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true; // Inicia o carregamento
    });

    final String email = _emailController.text;
    final String senha = _senhaController.text;

    // Tenta fazer o login
    Usuario? user = await usuarioService.register(email, senha);

    if (user != null) {
      setState(() {
        _isLoading = false; // Para o carregamento antes de iniciar a navegação
      });

      String? token = await usuarioService.login(email, senha);

      if (token != null) {
        setState(() {
          _isLoading =
              false; // Para o carregamento antes de iniciar a navegação
        });

        if (html.window.localStorage.containsKey('bearerToken')) {
          html.window.localStorage['bearerToken'] = token;
        } else {
          await storage.write(key: 'bearerToken', value: token);
        }

        await Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(title: "Dashboard"),
            ),
          );
        });
      } else {
        setState(() {
          _errorMessage = 'E-mail ou senha incorretos.'; // Mensagem de erro
          _isLoading = false; // Para o carregamento
        });
      }
    }
  }
}
