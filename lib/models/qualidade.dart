class Qualidade {
  String? id;
  String? timestamp;
  String? usuarioId;
  double? fatorPotencia;
  double? flutuacaoTensaoMinima;
  double? flutuacaoTensaoMaxima;
  double? thdTensao;
  double? thdCorrente;
  double? oscilacaoTensao;

  Qualidade(
      {this.id,
      this.timestamp,
      this.usuarioId,
      this.fatorPotencia,
      this.flutuacaoTensaoMinima,
      this.flutuacaoTensaoMaxima,
      this.thdTensao,
      this.thdCorrente,
      this.oscilacaoTensao});

  Qualidade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    usuarioId = json['usuarioId'];
    fatorPotencia = (json['fatorPotencia'] as num?)?.toDouble();
    flutuacaoTensaoMinima = (json['flutuacaoTensaoMinima'] as num?)?.toDouble();
    flutuacaoTensaoMaxima = (json['flutuacaoTensaoMaxima'] as num?)?.toDouble();
    thdTensao = (json['thdTensao'] as num?)?.toDouble();
    thdCorrente = (json['thdCorrente'] as num?)?.toDouble();
    oscilacaoTensao = (json['oscilacaoTensao'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['usuarioId'] = this.usuarioId;
    data['fatorPotencia'] = this.fatorPotencia;
    data['flutuacaoTensaoMinima'] = this.flutuacaoTensaoMinima;
    data['flutuacaoTensaoMaxima'] = this.flutuacaoTensaoMaxima;
    data['thdTensao'] = this.thdTensao;
    data['thdCorrente'] = this.thdCorrente;
    data['oscilacaoTensao'] = this.oscilacaoTensao;
    return data;
  }
}
