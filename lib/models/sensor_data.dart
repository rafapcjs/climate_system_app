
class SensorReading {
  final int id;
  final double temperatura;
  final double humedad;
  final double humedadSuelo;
  final String calidadAire;
  final String estadoAgua;
  final DateTime createdAt;

  SensorReading({
    required this.id,
    required this.temperatura,
    required this.humedad,
    required this.humedadSuelo,
    required this.calidadAire,
    required this.estadoAgua,
    required this.createdAt,
  });

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      id: json['id'] as int,
      temperatura: (json['temperatura'] as num).toDouble(),
      humedad: (json['humedad'] as num).toDouble(),
      humedadSuelo: (json['humedad_suelo'] as num).toDouble(),
      calidadAire: json['calidad_aire'] as String,
      estadoAgua: json['estado_agua'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
