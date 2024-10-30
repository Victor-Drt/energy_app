import 'dart:convert';
import 'package:energy_app/models/usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioService {
  final String baseUrl;

  UsuarioService({required this.baseUrl});

  // Método para registrar um novo usuário
  Future<Usuario?> register(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'senha': senha,
      }),
    );

    if (response.statusCode == 201) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      print('Erro ao registrar: ${response.statusCode}');
      return null;
    }
  }

  // Método para fazer login de um usuário e retornar o token JWT
  Future<String?> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {
      // Assume que o token JWT é retornado no corpo da resposta
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['token']; // Ajuste a chave conforme necessário
    } else {
      print('Erro ao fazer login: ${response.statusCode}');
      return null;
    }
  }
}
