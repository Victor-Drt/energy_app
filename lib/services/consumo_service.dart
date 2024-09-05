import 'dart:convert';

import 'package:energy_app/models/consumo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ConsumoService {
  final String baseUrl;

  ConsumoService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  Future<List<Consumo>> fetchConsumo() async {
    final url = Uri.parse('${baseUrl}consumos');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decodifica o corpo da resposta
        final List<dynamic> data = jsonDecode(response.body);
        // Converte a lista de mapas para uma lista de objetos Consumo
        return List<Consumo>.from(
          data.map((item) => Consumo.fromJson(item as Map<String, dynamic>)),
        );
      } else {
        // Lança uma exceção com a mensagem de erro
        throw Exception(
            'Falha ao carregar dados de consumo: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Lida com erros de rede ou outros erros
      throw Exception('Erro de rede: $e');
    }
  }

  Future<List<Consumo>> fetchConsumoByDispositivo(int dispositivoId) async {
    final url = Uri.parse('${baseUrl}consumos/dispositivo/$dispositivoId/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decodifica o corpo da resposta
        final List<dynamic> data = jsonDecode(response.body);
        // Converte a lista de mapas para uma lista de objetos Consumo
        return List<Consumo>.from(
          data.map((item) => Consumo.fromJson(item as Map<String, dynamic>)),
        );
      } else {
        // Lança uma exceção com a mensagem de erro
        throw Exception(
            'Falha ao carregar dados de consumo: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Lida com erros de rede ou outros erros
      throw Exception('Erro de rede: $e');
    }
  }
}
