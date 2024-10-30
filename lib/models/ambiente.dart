class Ambiente {
  String? id;
  String? usuarioId;
  String? nome;
  String? dataCriacao;
  int? qtdDispositivos;

  Ambiente(
      {this.id,
      this.usuarioId,
      this.nome,
      this.dataCriacao,
      this.qtdDispositivos});

  Ambiente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usuarioId = json['usuario_id'];
    nome = json['nome'];
    dataCriacao = json['data_criacao'];
    qtdDispositivos = json['qtd_dispositivos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['usuario_id'] = this.usuarioId;
    data['nome'] = this.nome;
    data['data_criacao'] = this.dataCriacao;
    data['qtd_dispositivos'] = this.qtdDispositivos;
    return data;
  }
}
