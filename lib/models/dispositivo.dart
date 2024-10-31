class Dispositivo {
  String? id;
  String? ambienteId;
  String? macAddress;
  bool? status;
  String? descricao;
  String? dataAtivacao;

  Dispositivo(
      {this.id,
      this.ambienteId,
      this.macAddress,
      this.status,
      this.descricao,
      this.dataAtivacao});

  Dispositivo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ambienteId = json['ambienteId'];
    macAddress = json['macAddress'];
    status = json['status'];
    descricao = json['descricao'];
    dataAtivacao = json['dataAtivacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ambienteId'] = this.ambienteId;
    data['macAddress'] = this.macAddress;
    data['status'] = this.status;
    data['descricao'] = this.descricao;
    data['dataAtivacao'] = this.dataAtivacao;
    return data;
  }
}
