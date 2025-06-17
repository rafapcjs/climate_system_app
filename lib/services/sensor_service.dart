

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor_data.dart';

/// Servicio para interactuar con la API de sensores
class SensorService {
  final String baseUrl;

  SensorService({this.baseUrl = 'https://climate-system.onrender.com'});

  /// Obtiene la última lectura del sensor
  Future<SensorReading> fetchLastReading() async {
    final uri = Uri.parse('$baseUrl/sensores/ultimo');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['status'] == 'ok') {
        return SensorReading.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('API returned status: ${data['status']}');
      }
    } else {
      throw Exception('HTTP error: ${response.statusCode}');
    }
  }
}