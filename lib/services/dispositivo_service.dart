import 'dart:convert';
import 'dart:io'; // Import para capturar erros de rede
import 'package:energy_app/models/dispositivo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DispositivoService {
  final String baseUrl;

  DispositivoService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  Future<List<Dispositivo>> fetchDispositivo() async {
    final url = Uri.parse('${baseUrl}dispositivos/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Dispositivo>.from(
          data.map(
              (item) => Dispositivo.fromJson(item as Map<String, dynamic>)),
        );
      } else {
        throw Exception(
            'Falha ao carregar dados de dispositivo: ${response.reasonPhrase}');
      }
    } on SocketException {
      // Caso não haja conexão com a internet, capturamos a exceção SocketException
      print('Sem conexão com a Internet');
      return []; // Retorna uma lista vazia ou trate conforme necessário
    } catch (e) {
      // Outros tipos de erros (por exemplo, erro no servidor ou erro de parse)
      print('Erro inesperado: $e');
      return [];
    }
  }
}
