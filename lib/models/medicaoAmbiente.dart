class MedicaoAmbiente {
  List<Devices>? devices;

  MedicaoAmbiente({this.devices});

  MedicaoAmbiente.fromJson(Map<String, dynamic> json) {
    if (json['devices'] != null) {
      devices = <Devices>[];
      json['devices'].forEach((v) {
        devices!.add(new Devices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.devices != null) {
      data['devices'] = this.devices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Devices {
  String? nome;
  List<RegistrosConsumo>? registrosConsumo;

  Devices({this.nome, this.registrosConsumo});

  Devices.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    if (json['registrosConsumo'] != null) {
      registrosConsumo = <RegistrosConsumo>[];
      json['registrosConsumo'].forEach((v) {
        registrosConsumo!.add(new RegistrosConsumo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    if (this.registrosConsumo != null) {
      data['registrosConsumo'] =
          this.registrosConsumo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RegistrosConsumo {
  double? potenciaAtivaKw;
  String? hora;

  RegistrosConsumo({this.potenciaAtivaKw, this.hora});

  RegistrosConsumo.fromJson(Map<String, dynamic> json) {
    potenciaAtivaKw = (json['potenciaAtivaKw'] as num?)?.toDouble();
    hora = json['hora'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['potenciaAtivaKw'] = this.potenciaAtivaKw;
    data['hora'] = this.hora;
    return data;
  }
}
