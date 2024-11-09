import 'package:energy_app/services/auth/token_mobile_service.dart';
import 'package:energy_app/services/auth/token_web_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

abstract class TokenService {
  Future<String?> getToken();
  Future<void> storeToken(String token);
  Future<void> removeToken();
}

TokenService getTokenService() {
  if (kIsWeb) {
    return TokenServiceWeb();
  } else {
    return TokenServiceMobile();
  }
}
