import 'dart:convert';
import 'package:energy_app/models/qualidade.dart';
import 'package:energy_app/services/auth/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QualidadeService {
  final String baseUrl;
  final TokenService _tokenService = getTokenService();

  QualidadeService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  // Método para gerar análise de qualidade no período fornecido
  Future<Qualidade?> gerarAnaliseQualidade({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final token = await _tokenService.getToken();

    if (token == null) {
      throw Exception('Token de autenticação não encontrado!');
    }

    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/qualidade/calcular?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return Qualidade.fromJson(data);
      } else {
        throw Exception('Erro ao realizar análise de qualidade: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao gerar análise de qualidade: $e');
      throw Exception('Falha na requisição de análise de qualidade.');
    }
  }

  // Método para listar o histórico de análises de qualidade
  Future<List<Qualidade>?> listarHistoricoAnalises() async {
    try {
      final token = await _tokenService.getToken();

      if (token == null) {
        throw Exception('Token de autenticação não encontrado!');
      }

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
        throw Exception('Erro ao obter histórico de análises: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao obter histórico de análises: $e');
      throw Exception('Falha na requisição de histórico de análises.');
    }
  }

  // Método para salvar o token
  Future<void> salvarToken(String token) async {
    await _tokenService.storeToken(token);
  }

  // Método para remover o token (logout)
  Future<void> removerToken() async {
    await _tokenService.removeToken();
  }
}
