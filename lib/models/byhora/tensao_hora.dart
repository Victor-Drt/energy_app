class TensaoHora {
  String? nome;
  List<Registros>? registros;

  TensaoHora({this.nome, this.registros});

  TensaoHora.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    if (json['registros'] != null) {
      registros = <Registros>[];
      json['registros'].forEach((v) {
        registros!.add(new Registros.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    if (this.registros != null) {
      data['registros'] = this.registros!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Registros {
  String? hora;
  double? tensaoMedia;

  Registros({this.hora, this.tensaoMedia});

  Registros.fromJson(Map<String, dynamic> json) {
    hora = json['hora'];
    tensaoMedia = (json['tensaoMedia'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hora'] = this.hora;
    data['tensaoMedia'] = this.tensaoMedia;
    return data;
  }
}
