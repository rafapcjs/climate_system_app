class SensorReading { 
  final int id;
  final double temperatura;
  final String estadoTemperatura;
  final double humedad;
  final String estadoHumedad;
  final double humedadSuelo;
  final String calidadAire;
  final String estadoAgua;
  final DateTime createdAt;

  SensorReading({
    required this.id,
    required this.temperatura,
    required this.estadoTemperatura,
    required this.humedad,
    required this.estadoHumedad,
    required this.humedadSuelo,
    required this.calidadAire,
    required this.estadoAgua,
    required this.createdAt,
  });

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      id: json['id'] as int,
      // Convertir los valores a double si son String y necesitan ser números
      temperatura: _parseToDouble(json['temperatura']),
      estadoTemperatura: json['estado_temperatura'] as String,
      humedad: _parseToDouble(json['humedad']),
      estadoHumedad: json['estado_humedad'] as String,
      humedadSuelo: _parseToDouble(json['humedad_suelo']),
      calidadAire: json['calidad_aire'] as String,
      estadoAgua: json['estado_agua'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Función para convertir valores String a double si es necesario
  static double _parseToDouble(dynamic value) {
    if (value is String) {
      // Si el valor es una cadena, intentamos convertirlo a double
      return double.tryParse(value) ?? 0.0; // Si no es un número válido, retornamos 0.0
    }
    // Si ya es num (double o int), lo retornamos como double
    return value is num ? value.toDouble() : 0.0;
  }
}
