import 'dart:convert';
import 'package:energy_app/models/indicadorDashboard.dart';
import 'package:energy_app/models/medicaoAmbiente.dart';
import 'package:energy_app/services/auth/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/medicao.dart';

class MedicaoService {
  final String baseUrl;
  final TokenService _tokenService = getTokenService();

  MedicaoService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  // Método para listar medições de um dispositivo específico em um determinado período
  Future<List<Medicao>> listarMedicoes({
    required String macAddress,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final token = await _tokenService.getToken();

      if (token == null) {
        throw Exception('Token de autenticação não encontrado!');
      }

      final response = await http.get(
        Uri.parse(
            '$baseUrl/medicoes/$macAddress?startDate=$startDate&endDate=$endDate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Medicao.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao listar medições: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao listar medições: $e');
      throw Exception('Falha na requisição de medições.');
    }
  }

  // Método para listar medições por ambiente
  Future<MedicaoAmbiente?> listarMedicoesPorAmbiente({
    required ambienteId,
    required startDate,
    required endDate,
  }) async {
    try {
      final token = await _tokenService.getToken();

      if (token == null) {
        throw Exception('Token de autenticação não encontrado!');
      }

      final response = await http.get(
        Uri.parse(
          '$baseUrl/medicoes/ambiente/$ambienteId?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return MedicaoAmbiente.fromJson(data);
      } else {
        throw Exception('Erro ao listar medições por ambiente: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao listar medições por ambiente: $e');
      throw Exception('Falha na requisição de medições por ambiente.');
    }
  }

  // Método para obter estatísticas
  Future<IndicadorDashboard?> obterEstatisticas({
    required startDate,
    required endDate,
  }) async {
    try {
      final token = await _tokenService.getToken();

      if (token == null) {
        throw Exception('Token de autenticação não encontrado!');
      }

      final response = await http.get(
        Uri.parse(
            '$baseUrl/medicoes/estatisticas?startDate=$startDate&endDate=$endDate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return IndicadorDashboard.fromJson(data);
      } else {
        throw Exception('Erro ao obter estatísticas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao obter estatísticas: $e');
      throw Exception('Falha na requisição de estatísticas.');
    }
  }
}
