import 'dart:convert';
import 'package:energy_app/models/indicadorDashboard.dart';
import 'package:energy_app/models/medicaoAmbiente.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/medicao.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:html' as html; // Importação para usar o localStorage no Flutter Web.

class MedicaoService {
  final String baseUrl;
  final _storage = const FlutterSecureStorage(); // Armazenamento seguro do token

  MedicaoService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  // Verifica se é possível usar o FlutterSecureStorage, senão tenta o localStorage no ambiente web
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

  // Método para listar medições de um dispositivo específico em um determinado período
  Future<List<Medicao>> listarMedicoes(
      {required macAddress, required startDate, required endDate}) async {
    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception('Token de autenticação não encontrado!');
      }

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
      final token = await _getToken();

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
      throw e;
    }
  }
}
