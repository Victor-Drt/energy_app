class Bloco {
  int? id;
  String? nome;
  String? createdAt;
  String? updatedAt;

  Bloco({this.id, this.nome, this.createdAt, this.updatedAt});

  Bloco.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
