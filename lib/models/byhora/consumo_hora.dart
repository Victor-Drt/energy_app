class ConsumoHora {
  String? nome;
  List<Registros>? registros;

  ConsumoHora({this.nome, this.registros});

  ConsumoHora.fromJson(Map<String, dynamic> json) {
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
  double? potenciaTotalKw;

  Registros({this.hora, this.potenciaTotalKw});

  Registros.fromJson(Map<String, dynamic> json) {
    hora = json['hora'];
    potenciaTotalKw = json['potenciaTotalKw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hora'] = this.hora;
    data['potenciaTotalKw'] = this.potenciaTotalKw;
    return data;
  }
}
