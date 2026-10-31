class Sensor {
  final int id;
  final String tipo;
  final String localizacao;
  final double? valorMedido;
  final String? unidade;

  Sensor({
    required this.id,
    required this.tipo,
    required this.localizacao,
    this.valorMedido,
    this.unidade,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'localizacao': localizacao,
      'valorMedido': valorMedido,
      'unidade': unidade,
    };
  }

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      tipo: json['tipo']?.toString() ?? '',
      localizacao: json['localizacao']?.toString() ?? '',
      valorMedido: (json['valorMedido'] as num?)?.toDouble(),
      unidade: json['unidade']?.toString(),
    );
  }
}
