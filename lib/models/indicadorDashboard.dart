class IndicadorDashboard {
  double? consumoDiario;
  double? consumoSemanal;
  double? consumoMensal;
  int? quantidadeAmbientes;
  double? tensaoMedia;

  IndicadorDashboard(
      {this.consumoDiario,
      this.consumoSemanal,
      this.consumoMensal,
      this.quantidadeAmbientes,
      this.tensaoMedia});

  IndicadorDashboard.fromJson(Map<String, dynamic> json) {
    consumoDiario = (json['consumoDiario'] as num?)?.toDouble();
    consumoSemanal = (json['consumoSemanal'] as num?)?.toDouble();
    consumoMensal = (json['consumoMensal'] as num?)?.toDouble();
    quantidadeAmbientes = json['quantidadeAmbientes'];
    tensaoMedia = (json['tensaoMedia'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consumoDiario'] = this.consumoDiario;
    data['consumoSemanal'] = this.consumoSemanal;
    data['consumoMensal'] = this.consumoMensal;
    data['quantidadeAmbientes'] = this.quantidadeAmbientes;
    data['tensaoMedia'] = this.tensaoMedia;
    return data;
  }
}
