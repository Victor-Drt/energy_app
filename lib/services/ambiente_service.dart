import 'dart:convert';
import 'package:energy_app/services/auth/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/ambiente.dart';

class AmbienteService {
  final String baseUrl;
  final TokenService _tokenService = getTokenService(); // Uso do TokenService para obter o token

  AmbienteService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  // Método para cadastrar um novo ambiente
  Future<bool> cadastrarAmbiente(Ambiente ambiente) async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Token de autenticação não encontrado!');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/ambientes/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"nome": ambiente.nome}),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Erro ao cadastrar ambiente: ${response.reasonPhrase} (Código: ${response.statusCode})');
        return false;
      }
    } catch (e) {
      print('Erro ao cadastrar ambiente: $e');
      return false;
    }
  }

  // Método para editar um ambiente existente
  Future<bool> editarAmbiente(String id, Ambiente ambiente) async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Token de autenticação não encontrado!');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/ambientes/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(ambiente.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro ao editar ambiente: ${response.reasonPhrase} (Código: ${response.statusCode})');
        return false;
      }
    } catch (e) {
      print('Erro ao editar ambiente: $e');
      return false;
    }
  }

  // Método para listar todos os ambientes em um período
  Future<List<Ambiente>> listarAmbientes({
    required startDate,
    required endDate,
  }) async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Token de autenticação não encontrado!');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/ambientes?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Ambiente.fromJson(json)).toList();
      } else {
        print('Erro ao listar ambientes: ${response.reasonPhrase} (Código: ${response.statusCode})');
        return [];
      }
    } catch (e) {
      print('Erro ao listar ambientes: $e');
      return [];
    }
  }

  // Método para deletar um ambiente
  Future<bool> deletarAmbiente(String id) async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Token de autenticação não encontrado!');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/ambientes/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        print('Erro ao deletar ambiente: ${response.reasonPhrase} (Código: ${response.statusCode})');
        return false;
      }
    } catch (e) {
      print('Erro ao deletar ambiente: $e');
      return false;
    }
  }
}
