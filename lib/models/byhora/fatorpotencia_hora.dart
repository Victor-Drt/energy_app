class FatorPTHora {
  String? nome;
  List<Registros>? registros;

  FatorPTHora({this.nome, this.registros});

  FatorPTHora.fromJson(Map<String, dynamic> json) {
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
  double? fatorPotenciaMedia;

  Registros({this.hora, this.fatorPotenciaMedia});

  Registros.fromJson(Map<String, dynamic> json) {
    hora = json['hora'];
    fatorPotenciaMedia = json['fatorPotenciaMedia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hora'] = this.hora;
    data['fatorPotenciaMedia'] = this.fatorPotenciaMedia;
    return data;
  }
}
