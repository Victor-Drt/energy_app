import 'dart:convert';
import 'dart:io';
import 'package:energy_app/models/dispositivo.dart';
import 'package:energy_app/services/auth/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DispositivoService {
  final String baseUrl;
  final TokenService _tokenService = getTokenService(); // Uso do TokenService para obtenção do token

  DispositivoService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["api"] ?? "";

  // Método para buscar dispositivos de um ambiente específico
  Future<List<Dispositivo>> fetchDispositivo(String? ambienteId) async {
    final url = Uri.parse('${baseUrl}/dispositivos/$ambienteId');
    final token = await _tokenService.getToken();

    if (token == null) {
      throw Exception('Token de autenticação não encontrado!');
    }

    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      // Verifica o status da resposta
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Dispositivo>.from(
          data.map((item) => Dispositivo.fromJson(item as Map<String, dynamic>)),
        );
      } else {
        throw Exception('Falha ao carregar dispositivos: ${response.reasonPhrase} (Código: ${response.statusCode})');
      }
    } on SocketException {
      print('Erro de rede: Sem conexão com a Internet.');
      throw Exception('Sem conexão com a Internet. Tente novamente mais tarde.');
    } catch (e) {
      print('Erro inesperado ao buscar dispositivos: $e');
      throw Exception('Erro inesperado ao buscar dispositivos.');
    }
  }

  // Método para cadastrar um novo dispositivo
  Future<Dispositivo?> cadastrarDispositivo(Dispositivo dispositivo) async {
    final token = await _tokenService.getToken();

    if (token == null) {
      throw Exception('Token de autenticação não encontrado!');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/dispositivos/'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode({
          "ambienteId": dispositivo.ambienteId,
          "descricao": dispositivo.descricao,
          "macAddress": dispositivo.macAddress,
        }),
      );

      // Verifica o status da resposta
      if (response.statusCode == 201) {
        return Dispositivo.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erro ao cadastrar dispositivo: ${response.reasonPhrase} (Código: ${response.statusCode})');
      }
    } catch (e) {
      print('Erro inesperado ao cadastrar dispositivo: $e');
      throw Exception('Erro inesperado ao cadastrar dispositivo.');
    }
  }
}
