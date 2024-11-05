class Dados {
  final List<Dispositivo> dispositivos;

  Dados({required this.dispositivos});

  factory Dados.fromJson(Map<String, dynamic> json) {
    var list = json['dispositivos'] as List;
    List<Dispositivo> dispositivosList = list.map((i) => Dispositivo.fromJson(i)).toList();

    return Dados(dispositivos: dispositivosList);
  }
}

class Dispositivo {
  final String nome;
  final List<MedicaoAmbiente> medicoes;

  Dispositivo({required this.nome, required this.medicoes});

  factory Dispositivo.fromJson(Map<String, dynamic> json) {
    var list = json['medicoes'] as List;
    List<MedicaoAmbiente> medicoesList = list.map((i) => MedicaoAmbiente.fromJson(i)).toList();

    return Dispositivo(
      nome: json['nome'],
      medicoes: medicoesList,
    );
  }
}


class MedicaoAmbiente {
  final String hora;
  final double potenciaAtivaKw;

  MedicaoAmbiente({
    required this.hora,
    required this.potenciaAtivaKw,
  });

  factory MedicaoAmbiente.fromJson(Map<String, dynamic> json) {
    try {
      // Converte a string para DateTime
      return MedicaoAmbiente(
        hora: json['hora'], // Esta linha converte a string para DateTime
        potenciaAtivaKw: json['potenciaAtivaKw'],
      );
    } catch (e) {
      print('Erro ao converter a hora: ${json['hora']}. Erro: $e');
      throw FormatException('Erro ao converter a hora para DateTime: ${json['hora']}');
    }
  }
}

