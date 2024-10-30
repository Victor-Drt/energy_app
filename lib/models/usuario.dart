import 'dart:convert';
import 'package:crypto/crypto.dart';

class Usuario {
  String id;
  String email;
  String senha;

  Usuario({
    required this.id,
    required this.email,
    required this.senha,
  });

  // Método para converter JSON em um objeto Usuario
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String,
      email: json['email'] as String,
      senha: json['senha'] as String,
    );
  }

  // Método para converter um objeto Usuario em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'senha': senha,
    };
  }

  // Método para verificar a senha
  bool checkPassword(String senha) {
    return _hashPassword(senha) == this.senha;
  }

  // Método para fazer hash da senha
  static String _hashPassword(String senha) {
    final bytes = utf8.encode(senha);
    final digest = sha256.convert(bytes);
    return digest.toString(); // Retorna o hash da senha
  }
}
