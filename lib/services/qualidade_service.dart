import 'dart:convert';
import 'package:energy_app/models/qualidade.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:html' as html; // Para acessar o localStorage na web

class QualidadeService {
  final String baseUrl;
  final _storage = const FlutterSecureStorage(); // Armazenamento seguro do token

  QualidadeService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  // Verifica se é possível usar o FlutterSecureStorage, senão tenta o localStorage no ambiente web
  Future<String?> _getToken() async {
    String? token;

    try {
      token = await _storage.read(key: 'bearerToken');
    } catch (e) {
      print('Erro ao usar FlutterSecureStorage: $e');
    }

    // Se falhar em obter o token do FlutterSecureStorage, tenta o localStorage (apenas no Flutter Web)
    if (token == null && isWeb()) {
      try {
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

  // Método para gerar análise de qualidade no período fornecido
  Future<Qualidade?> gerarAnaliseQualidade({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final token = await _getToken();

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
      final token = await _getToken();

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

  // Método para salvar o token usando FlutterSecureStorage ou localStorage (em web)
  Future<void> salvarToken(String token) async {
    try {
      await _storage.write(key: 'bearerToken', value: token);
    } catch (e) {
      print('Erro ao salvar token com FlutterSecureStorage, tentando localStorage...');
      if (isWeb()) {
        html.window.localStorage['bearerToken'] = token;
      }
    }
  }

  // Método para remover o token (logout) usando FlutterSecureStorage ou localStorage (em web)
  Future<void> removerToken() async {
    try {
      await _storage.delete(key: 'bearerToken');
    } catch (e) {
      print('Erro ao remover token com FlutterSecureStorage, tentando localStorage...');
      if (isWeb()) {
        html.window.localStorage.remove('bearerToken');
      }
    }
  }
}
