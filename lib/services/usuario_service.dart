import 'dart:convert';
import 'package:energy_app/models/usuario.dart';
import 'package:energy_app/services/auth/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UsuarioService {
  final String baseUrl;
  final TokenService _tokenService = getTokenService();

  UsuarioService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

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

  // Método para fazer login de um usuário e armazenar o token JWT
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
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData['token'];

      // Armazena o token de forma segura dependendo da plataforma
      await _tokenService.storeToken(token);

      return token;
    } else {
      print('Erro ao fazer login: ${response.statusCode}');
      return null;
    }
  }

  // Método para recuperar o token JWT armazenado
  Future<String?> getToken() async {
    return await _tokenService.getToken();
  }

  // Método para fazer logout e remover o token armazenado
  Future<void> logout() async {
    await _tokenService.removeToken();
  }
}
