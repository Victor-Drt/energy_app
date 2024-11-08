class PotenciaReativaHora {
  String? nome;
  List<Registros>? registros;

  PotenciaReativaHora({this.nome, this.registros});

  PotenciaReativaHora.fromJson(Map<String, dynamic> json) {
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
  double? potenciaReativaMedia;

  Registros({this.hora, this.potenciaReativaMedia});

  Registros.fromJson(Map<String, dynamic> json) {
    hora = json['hora'];
    potenciaReativaMedia = json['potenciaReativaMedia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hora'] = this.hora;
    data['potenciaReativaMedia'] = this.potenciaReativaMedia;
    return data;
  }
}
