import 'package:universal_html/html.dart' as html;
import 'token_service.dart';

class TokenServiceWeb implements TokenService {
  @override
  Future<String?> getToken() async {
    try {
      return html.window.localStorage['bearerToken'];
    } catch (e) {
      print('Erro ao obter token do localStorage: $e');
      return null;
    }
  }

  @override
  Future<void> storeToken(String token) async {
    try {
      html.window.localStorage['bearerToken'] = token;
    } catch (e) {
      print('Erro ao armazenar token no localStorage: $e');
    }
  }

  @override
  Future<void> removeToken() async {
    try {
      html.window.localStorage.remove('bearerToken');
    } catch (e) {
      print('Erro ao remover token do localStorage: $e');
    }
  }
}
