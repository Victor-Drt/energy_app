import 'dart:convert';
import 'package:energy_app/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UsuarioService {
  final String baseUrl;
  final _storage = const FlutterSecureStorage();

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
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData['token']; // Ajuste a chave conforme necessário

      // Armazena o token de forma segura
      await _storage.write(key: 'bearerToken', value: token);
      
      return token;
    } else {
      print('Erro ao fazer login: ${response.statusCode}');
      return null;
    }
  }

  // Método para recuperar o token JWT armazenado
  Future<String?> getToken() async {
    return await _storage.read(key: 'bearerToken');
  }

  // Método para fazer logout e remover o token armazenado
  Future<void> logout() async {
    await _storage.delete(key: 'bearerToken');
  }
}
