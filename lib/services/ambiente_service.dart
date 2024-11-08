import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/ambiente.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:html' as html;

class AmbienteService {
  final String baseUrl;
  final _storage =
      const FlutterSecureStorage(); // Armazenamento seguro do token

  AmbienteService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  Future<String?> _getToken() async {
    String? token;

    try {
      // Tenta obter o token do FlutterSecureStorage
      token = await _storage.read(key: 'bearerToken');
    } catch (e) {
      print('Erro ao usar FlutterSecureStorage: $e');
    }

    // Se falhar em obter o token do FlutterSecureStorage, tenta o localStorage (apenas no Flutter Web)
    if (token == null && isWeb()) {
      try {
        // Tenta acessar o localStorage no ambiente Web
        token = html.window.localStorage['bearerToken'];
      } catch (e) {
        print('Erro ao usar localStorage: $e');
      }
    }

    return token;
  }

  // Verifica se a plataforma é Web (flutter web)
  bool isWeb() {
    try {
      return identical(0, 0.0); // Se estivermos no Flutter Web, isso retorna true
    } catch (e) {
      return false;
    }
  }

  // Cadastrar um novo ambiente
  Future<bool> cadastrarAmbiente(Ambiente ambiente) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/ambientes/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Inclui o token JWT
      },
      body: jsonEncode({"nome": ambiente.nome}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Erro ao cadastrar ambiente: ${response.statusCode}');
      return false;
    }
  }

  // Editar um ambiente existente
  Future<bool> editarAmbiente(String id, Ambiente ambiente) async {
    final token = await _getToken(); // Recupera o token armazenado

    final response = await http.put(
      Uri.parse('$baseUrl/ambientes/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Inclui o token JWT
      },
      body: jsonEncode(ambiente.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Erro ao editar ambiente: ${response.statusCode}');
      return false;
    }
  }

  // Listar todos os ambientes
  Future<List<Ambiente>> listarAmbientes({
    required startDate,
    required endDate,
  }) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/ambientes?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Ambiente.fromJson(json)).toList();
    } else {
      print('Erro ao listar ambientes: ${response.statusCode}');
      return [];
    }
  }

  // Deletar um ambiente
  Future<bool> deletarAmbiente(String id) async {
    final token = await _getToken(); // Recupera o token armazenado

    final response = await http.delete(
      Uri.parse('$baseUrl/ambientes/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Inclui o token JWT
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      print('Erro ao deletar ambiente: ${response.statusCode}');
      return false;
    }
  }
}
