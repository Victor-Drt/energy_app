import 'dart:convert';
import 'package:energy_app/models/indicadorDashboard.dart';
import 'package:energy_app/models/medicaoAmbiente.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/medicao.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MedicaoService {
  final String baseUrl;
  final _storage =
      const FlutterSecureStorage(); // Armazenamento seguro do token

  MedicaoService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  Future<String?> _getToken() async {
    return await _storage.read(key: 'bearerToken');
  }

  // Método para listar medições de um dispositivo específico em um determinado período
  Future<List<Medicao>> listarMedicoes(
      {required macAddress, required startDate, required endDate}) async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse(
            '$baseUrl/medicoes/$macAddress?startDate=$startDate&endDate=$endDate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Inclui o token JWT
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
      throw e;
    }
  }

  Future<MedicaoAmbiente?> listarMedicoesPorAmbiente({
    required ambienteId,
    required startDate,
    required endDate,
  }) async {
    try {
      // Obtém o token de autenticação
      final token = await _getToken();

      // Realiza a requisição GET para o endpoint da API
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

        if (data.containsKey('devices') && data['devices'] is List) {
          return MedicaoAmbiente.fromJson(data);
        } else {
          print('Estrutura inesperada da resposta JSON: $data');
          return null;
        }
      } else {
        print('Erro ao listar medições: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro ao listar medições por ambiente: $e');
      throw e;
    }
  }

  Future<IndicadorDashboard?> obterEstatisticas({required startDate, required endDate}) async {
    try {
      final token = await _getToken();

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
      throw e;
    }
  }
}
