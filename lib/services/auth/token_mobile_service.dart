import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'token_service.dart';

class TokenServiceMobile implements TokenService {
  final _storage = const FlutterSecureStorage();

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: 'bearerToken');
  }

  @override
  Future<void> storeToken(String token) async {
    await _storage.write(key: 'bearerToken', value: token);
  }

  @override
  Future<void> removeToken() async {
    await _storage.delete(key: 'bearerToken');
  }
}
