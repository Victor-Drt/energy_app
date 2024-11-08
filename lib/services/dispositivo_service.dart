import 'dart:convert';
import 'dart:io'; // Import para capturar erros de rede
import 'package:energy_app/models/dispositivo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Para armazenamento seguro do token

class DispositivoService {
  final String baseUrl;
  final _storage = const FlutterSecureStorage(); // Armazenamento seguro do token

  DispositivoService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  Future<String?> _getToken() async {
    return await _storage.read(key: 'bearerToken');
  }

  // Método para buscar dispositivos de um ambiente específico
  Future<List<Dispositivo>> fetchDispositivo(String? ambienteId) async {
    final url = Uri.parse('${baseUrl}/dispositivos/$ambienteId');
    final token = await _getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token', // Adiciona o token no cabeçalho de autorização
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      // Verifica o status da resposta
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
      print('Sem conexão com a Internet');
      return []; // Retorna uma lista vazia ou trate conforme necessário
    } catch (e) {
      print('Erro inesperado: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  // Método para cadastrar um novo dispositivo
  Future<Dispositivo?> cadastrarDispositivo(Dispositivo dispositivo) async {
    final token = await _getToken();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/dispositivos/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Inclui o token JWT
        },
        body: jsonEncode({
          "ambienteId": dispositivo.ambienteId,
          "descricao": dispositivo.descricao,
          "macAddress": dispositivo.macAddress
        }),
      );

      // Verifica o status da resposta
      if (response.statusCode == 201) {
        return Dispositivo.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erro ao cadastrar dispositivo: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro inesperado: $e');
      return null; // Retorna null em caso de erro
    }
  }
}
