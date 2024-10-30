import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ambiente.dart';

class AmbienteService {
  final String baseUrl;
  final String token; // Adiciona o token JWT aqui

  AmbienteService({required this.baseUrl, required this.token});

  // Cadastrar um novo ambiente
  Future<Ambiente?> cadastrarAmbiente(Ambiente ambiente) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ambientes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Inclui o token JWT
      },
      body: jsonEncode(ambiente.toJson()),
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
    final response = await http.get(
      Uri.parse('$baseUrl/ambientes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Inclui o token JWT
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
