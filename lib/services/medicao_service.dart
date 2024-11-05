import 'dart:convert';
import 'package:energy_app/models/medicaoAmbeinte.dart';
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

  // Método para listar medições de dispositivos em um ambiente específico
  Future<List<Medicao>> listarMedicoesPorAmbienteOld(
      String ambienteId, String startDate, String endDate) async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse(
            '$baseUrl/medicoes/ambiente/$ambienteId?startDate=$startDate&endDate=$endDate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Inclui o token JWT
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Medicao.fromJson(item)).toList();
      } else {
        throw Exception(
            'Erro ao listar medições por ambiente: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao listar medições por ambiente: $e');
      throw e;
    }
  }

Future<Dados?> listarMedicoesPorAmbiente({
  required ambienteId,
  required startDate,
  required endDate,
}) async {
  try {
    final token = await _getToken(); // Certifique-se de que você está obtendo o token corretamente
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
      // Decodifica a resposta JSON
      final Map<String, dynamic> data = jsonDecode(response.body);
      print('Dados recebidos: $data');

      // Verifica se o JSON possui a chave 'dispositivos' e se é uma lista
      if (data.containsKey('dispositivos') && data['dispositivos'] is List) {
        return Dados.fromJson(data);
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

  // Método para obter estatísticas de medições
  Future<Map<String, dynamic>> obterEstatisticas(
      String startDate, String endDate) async {
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
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ao obter estatísticas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao obter estatísticas: $e');
      throw e;
    }
  }
}
