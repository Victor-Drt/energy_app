class Ambiente {
  String? id;
  String? usuarioId;
  String? nome;
  String? dataCriacao;
  String? consumoAcumuladokWh;
  int? qtdDispositivos;

  Ambiente(
      {this.id,
      this.usuarioId,
      this.nome,
      this.dataCriacao,
      this.consumoAcumuladokWh,
      this.qtdDispositivos});

  Ambiente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usuarioId = json['usuarioId'];
    nome = json['nome'];
    dataCriacao = json['dataCriacao'];
    qtdDispositivos = json['qtdDispositivos'];
    consumoAcumuladokWh = json['consumoAcumuladokWh'].toStringAsFixed(3).toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['usuarioId'] = this.usuarioId;
    data['nome'] = this.nome;
    data['dataCriacao'] = this.dataCriacao;
    data['qtdDispositivos'] = this.qtdDispositivos;
    data['consumoAcumuladokWh'] = this.consumoAcumuladokWh;
    return data;
  }
}
