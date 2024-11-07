import 'dart:convert';
import 'package:energy_app/models/qualidade.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QualidadeService {
  final String baseUrl;
  final _storage =
      const FlutterSecureStorage(); // Armazenamento seguro do token

  QualidadeService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  Future<String?> _getToken() async {
    return await _storage.read(key: 'bearerToken');
  }

  Future<Qualidade?> gerarAnaliseQualidade({
    required startDate,
    required endDate,
  }) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(
          '$baseUrl/qualidade/calcular?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return Qualidade.fromJson(data);
    } else {
      throw Exception('Erro ao fazer analise: ${response.statusCode}');
    }
  }

  Future<List<Qualidade>?> listarHistoricoAnalises() async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/qualidade'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Qualidade.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao obter historico: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao obter estatísticas: $e');
      throw e;
    }
  }
}
