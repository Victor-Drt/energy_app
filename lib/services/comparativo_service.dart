import 'dart:convert';
import 'package:energy_app/models/byhora/consumo_hora.dart';
import 'package:energy_app/models/byhora/fatorpotencia_hora.dart';
import 'package:energy_app/models/byhora/potenciareativa_hora.dart';
import 'package:energy_app/models/byhora/tensao_hora.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:html'
    as html; // Importação para usar o localStorage no Flutter Web.

class ComparativoService {
  final String baseUrl;
  final _storage = const FlutterSecureStorage();

  ComparativoService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

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

  bool isWeb() {
    try {
      return identical(
          0, 0.0); // Se estivermos no Flutter Web, isso retorna true
    } catch (e) {
      return false;
    }
  }

  Future<List<ConsumoHora>> obterConsumoDia({required dia}) async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/medicoes/consumo-hora?dia=$dia'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => ConsumoHora.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao obter historico: ${response.statusCode}');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<TensaoHora>> obterTensaoDia({required dia}) async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/medicoes/tensao-hora?dia=$dia'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => TensaoHora.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao obter historico: ${response.statusCode}');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<PotenciaReativaHora>> obterPtReativaDia({required dia}) async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/medicoes/ptreativa-hora?dia=$dia'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => PotenciaReativaHora.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao obter historico: ${response.statusCode}');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<FatorPTHora>> obterFatorPotenciaDia({required dia}) async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/medicoes/fatorpt-hora?dia=$dia'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => FatorPTHora.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao obter historico: ${response.statusCode}');
      }
    } catch (e) {
      throw e;
    }
  }
}
