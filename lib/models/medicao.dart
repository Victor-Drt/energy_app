class Medicao {
  String? id;
  String? dispositivoId;
  String? timestamp;
  double? corrente;
  double? tensao;
  double? potenciaAtiva;
  double? potenciaReativa;
  double? consumoAcumulado;

  Medicao({
    this.id,
    this.dispositivoId,
    this.timestamp,
    this.corrente,
    this.tensao,
    this.potenciaAtiva,
    this.potenciaReativa,
    this.consumoAcumulado,
  });

  Medicao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dispositivoId = json['dispositivoId'];
    timestamp = json['timestamp'];
    corrente = _toDouble(json['corrente']);
    tensao = _toDouble(json['tensao']);
    potenciaAtiva = _toDouble(json['potenciaAtiva']);
    potenciaReativa = _toDouble(json['potenciaReativa']);
    consumoAcumulado = _toDouble(json['consumoAcumulado']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dispositivoId': dispositivoId,
      'timestamp': timestamp,
      'corrente': corrente,
      'tensao': tensao,
      'potenciaAtiva': potenciaAtiva,
      'potenciaReativa': potenciaReativa,
      'consumoAcumulado': consumoAcumulado,
    };
  }

  // Função auxiliar para converter valores para double
  double? _toDouble(dynamic value) {
    if (value == null) {
      return null; // Retorna null se o valor for null
    } else if (value is double) {
      return value; // Já é um double
    } else if (value is int) {
      return value.toDouble(); // Converte de int para double
    } else if (value is String) {
      return double.tryParse(value) ?? null; // Converte de String para double, se possível
    }
    return null; // Retorna null se não puder converter
  }
}
