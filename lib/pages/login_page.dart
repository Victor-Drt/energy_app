import 'package:energy_app/pages/home_page.dart';
import 'package:energy_app/services/usuario_service.dart'; // Certifique-se de importar o serviço
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Importa a biblioteca jwt_decoder

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
  final storage = const FlutterSecureStorage(); // Instância para armazenamento seguro

  final UsuarioService usuarioService = UsuarioService(); // Defina sua URL base

  @override
  void initState() {
    super.initState();
    _checkToken(); // Verifica o token ao iniciar a página
  }

  Future<void> _checkToken() async {
    String? token = await storage.read(key: 'bearerToken');
    
    if (token != null && !JwtDecoder.isExpired(token)) {
      // Se o token é válido e não expirou, navegue para a página inicial
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
              onPressed: _isLoading
                  ? null
                  : _login, // Desabilita o botão enquanto está carregando
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

    if (token != null) {

      setState(() {
        _isLoading = false; // Para o carregamento antes de iniciar a navegação
      });

      // Use um Future.delayed para garantir que o estado do widget se estabilize antes de navegar
      await Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(title: "Dashboard"),
          ),
        );
      });
    } else {
      // Se falhar, exiba uma mensagem de erro
      setState(() {
        _errorMessage = 'E-mail ou senha incorretos.'; // Mensagem de erro
        _isLoading = false; // Para o carregamento
      });
    }
  }
}
