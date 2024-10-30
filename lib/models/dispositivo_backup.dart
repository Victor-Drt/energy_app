class Dispositivo {
  int? id;
  String? nome;
  int? blocoId;
  String? createdAt;
  String? updatedAt;

  Dispositivo(
      {this.id, this.nome, this.blocoId, this.createdAt, this.updatedAt});

  Dispositivo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    blocoId = json['blocoId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['blocoId'] = this.blocoId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
