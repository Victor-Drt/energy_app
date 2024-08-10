// List<Consumo> consumosFromJson(String str) =>
//     List<Consumo>.from(json.decode(str).map((x) => Consumo.fromJson(x)));

class Consumo {
  int? id;
  String? valor;
  int? dispositivoId;
  String? createdAt;
  String? updatedAt;

  Consumo(
      {this.id,
      this.valor,
      this.dispositivoId,
      this.createdAt,
      this.updatedAt});

  Consumo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    valor = json['valor'];
    dispositivoId = json['dispositivoId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['valor'] = this.valor;
    data['dispositivoId'] = this.dispositivoId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
