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

  Future<List<Dispositivo>> fetchDispositivo() async {
    final url = Uri.parse('${baseUrl}dispositivos/ca3b41d7-529f-47c1-ad9d-04a4686dc64e');
    // final token = await _getToken(); // Recupera o token armazenado
    final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5MzFmYjk2MS1lYzllLTQyYjUtYjIwMC01N2ZiOTYwNjk0ZTAiLCJpYXQiOjE3MzA0MDA1MDQsImV4cCI6MTczMDQwNDEwNH0.J2uMvdYSxVP4gv0P6FF6ALgnJ8hIxSDZd6wFufDcqm8";

    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token', // Adiciona o token no cabeçalho de autorização
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

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
      return [];
    }
  }
}
