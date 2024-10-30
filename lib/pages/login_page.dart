import 'package:energy_app/pages/dashboard_page.dart';
import 'package:energy_app/pages/home_page.dart';
import 'package:energy_app/services/usuario_service.dart'; // Certifique-se de importar o serviço
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  
  String? _errorMessage; // Mensagem de erro
  bool _isLoading = false; // Para indicar o carregamento

  final UsuarioService usuarioService = UsuarioService(baseUrl: 'http://10.151.0.180:3000'); // Defina sua URL base

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                  errorText: _errorMessage, // Exibe a mensagem de erro
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                  errorText: _errorMessage, // Exibe a mensagem de erro
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _login, // Desabilita o botão enquanto está carregando
              child: _isLoading 
                ? CircularProgressIndicator() // Mostra um indicador de carregamento
                : Text("Entrar"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _errorMessage = null; // Limpa a mensagem de erro anterior
      _isLoading = true; // Inicia o carregamento
    });

    final String email = _emailController.text;
    final String senha = _senhaController.text;

    // Tenta fazer o login
    String? token = await usuarioService.login(email, senha);

    setState(() {
      _isLoading = false; // Para o carregamento
    });

    if (token != null) {
      // Se o login foi bem-sucedido, armazene o token e navegue para a DashboardPage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token); // Armazena o token

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(title: "Dashboard"), // Certifique-se de que a DashboardPage está implementada
        ),
      );
    } else {
      // Se falhar, exiba uma mensagem de erro
      setState(() {
        _errorMessage = 'E-mail ou senha incorretos.'; // Mensagem de erro
      });
    }
  }
}
