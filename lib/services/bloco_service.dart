import 'package:energy_app/models/bloco.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:io'; // Import necessário para capturar erros de rede (SocketException)
import 'package:http/http.dart' as http;

class BlocoService {
  final String baseUrl;

  BlocoService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  Future<List<Bloco>> fetchBloco() async {
    final url = Uri.parse('${baseUrl}blocos');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Bloco>.from(
          data.map((item) => Bloco.fromJson(item as Map<String, dynamic>)),
        );
      } else {
        throw Exception(
            'Falha ao carregar dados de blocos: ${response.reasonPhrase}');
      }
    } on SocketException {
      // Captura a exceção de falta de conexão
      print('Sem conexão com a Internet');
      return []; // Retorna uma lista vazia em caso de erro de rede
    } catch (e) {
      // Trata outros tipos de erro (ex.: falha ao decodificar JSON, erro no servidor)
      print('Erro inesperado: $e');
      return [];
    }
  }
}
