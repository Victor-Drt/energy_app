import 'dart:convert';
import 'package:energy_app/models/byhora/consumo_hora.dart';
import 'package:energy_app/models/byhora/fatorpotencia_hora.dart';
import 'package:energy_app/models/byhora/potenciareativa_hora.dart';
import 'package:energy_app/models/byhora/tensao_hora.dart';
import 'package:energy_app/services/auth/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ComparativoService {
  final String baseUrl;
  final TokenService _tokenService = getTokenService(); // Uso do TokenService para obter o token

  ComparativoService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  // Método para obter o consumo de um dia específico
  Future<List<ConsumoHora>> obterConsumoDia({required String dia}) async {
    return await _fetchDadosDia<ConsumoHora>(
      endpoint: 'consumo-hora',
      dia: dia,
      fromJson: (item) => ConsumoHora.fromJson(item),
    );
  }

  // Método para obter a tensão de um dia específico
  Future<List<TensaoHora>> obterTensaoDia({required String dia}) async {
    return await _fetchDadosDia<TensaoHora>(
      endpoint: 'tensao-hora',
      dia: dia,
      fromJson: (item) => TensaoHora.fromJson(item),
    );
  }

  // Método para obter a potência reativa de um dia específico
  Future<List<PotenciaReativaHora>> obterPtReativaDia({required String dia}) async {
    return await _fetchDadosDia<PotenciaReativaHora>(
      endpoint: 'ptreativa-hora',
      dia: dia,
      fromJson: (item) => PotenciaReativaHora.fromJson(item),
    );
  }

  // Método para obter o fator de potência de um dia específico
  Future<List<FatorPTHora>> obterFatorPotenciaDia({required String dia}) async {
    return await _fetchDadosDia<FatorPTHora>(
      endpoint: 'fatorpt-hora',
      dia: dia,
      fromJson: (item) => FatorPTHora.fromJson(item),
    );
  }

  // Método genérico para obter dados por hora de um endpoint específico
  Future<List<T>> _fetchDadosDia<T>({
    required String endpoint,
    required String dia,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Token de autenticação não encontrado!');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/medicoes/$endpoint?dia=$dia'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Erro ao obter dados: ${response.reasonPhrase} (Código: ${response.statusCode})');
      }
    } catch (e) {
      print('Erro ao obter dados do endpoint $endpoint: $e');
      throw Exception('Erro inesperado ao obter dados do endpoint $endpoint.');
    }
  }
}
