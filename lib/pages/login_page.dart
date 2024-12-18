import 'package:energy_app/pages/home_page.dart';
import 'package:energy_app/services/usuario_service.dart'; // Certifique-se de importar o serviço
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:universal_html/html.dart' as html;

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
  bool isObscure1 = true;
  bool isObscure2 = true;

  final storage =
      const FlutterSecureStorage(); // Instância para armazenamento seguro

  final UsuarioService usuarioService = UsuarioService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Bem Vindo de Volta!',
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
                    onPressed: _isLoading ? null : _login,
                    child: const Text(
                      'Entrar',
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

      // Armazena o token dependendo da plataforma
      if (html.window.localStorage.containsKey('bearerToken')) {
        // Se for web, usa localStorage
        html.window.localStorage['bearerToken'] = token;
      } else {
        // Se for dispositivo móvel, usa FlutterSecureStorage
        await storage.write(key: 'bearerToken', value: token);
      }

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
