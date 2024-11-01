import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/ambiente.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AmbienteService {
  final String baseUrl;
  final _storage =
      const FlutterSecureStorage(); // Armazenamento seguro do token

  AmbienteService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  Future<String?> _getToken() async {
    return await _storage.read(key: 'bearerToken');
  }

  // Cadastrar um novo ambiente
  Future<Ambiente?> cadastrarAmbiente(Ambiente ambiente) async {
    final token = await _getToken();
    print("IAAA: ${ambiente.nome}");

    final response = await http.post(
      Uri.parse('$baseUrl/ambientes/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Inclui o token JWT
      },
      body: jsonEncode({"nome": ambiente.nome}),
    );

    if (response.statusCode == 201) {
      return Ambiente.fromJson(jsonDecode(response.body));
    } else {
      print('Erro ao cadastrar ambiente: ${response.statusCode}');
      return null;
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
  Future<List<Ambiente>> listarAmbientes() async {
    final token = await _getToken(); // Recupera o token armazenado
    final response = await http.get(
      Uri.parse('$baseUrl/ambientes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Inclui o token JWT
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print(data);
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
