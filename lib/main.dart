import 'dart:async';
import 'package:flutter/material.dart';
import 'models/sensor_data.dart';
import 'services/sensor_service.dart';

void main() => runApp(const SensorApp());

class SensorApp extends StatelessWidget {
  const SensorApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Monitor Ambiental',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF2A2D3E),
          scaffoldBackgroundColor: const Color(0xFF212332),
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF2697FF),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2697FF)),
            ),
            labelStyle: const TextStyle(color: Colors.white70),
          ),
        ),
        home: const LoginScreen(),
      );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscureText = true;
  String? _error;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _login() {
    if (_userController.text == 'admin' && _passController.text == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SensorHomePage()),
      );
    } else {
      setState(() => _error = 'Usuario o contraseña incorrectos');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1F38), Color(0xFF2A2D3E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/images/logoApp.png',
                    height: size.height * 0.15,
                    errorBuilder: (_, __, ___) => const Text('Imagen no encontrada', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 40),
                  const Text('Monitor Ambiental', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text('Inicia sesión para continuar', style: TextStyle(color: Colors.white60, fontSize: 16)),
                  const SizedBox(height: 40),
                  _buildLoginBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginBox() => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2D3E),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          TextField(
            controller: _userController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Usuario',
              prefixIcon: Icon(Icons.person_outline, color: Colors.white70),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passController,
            obscureText: _obscureText,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.redAccent))
          ],
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2697FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'INGRESAR',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]),  
      );
}

class SensorHomePage extends StatefulWidget {
  const SensorHomePage({super.key});

  @override
  _SensorHomePageState createState() => _SensorHomePageState();
}

class _SensorHomePageState extends State<SensorHomePage> {
  final _service = SensorService();
  late Future<SensorReading> _futureReading;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchReading();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) => _fetchReading());
  }

  void _fetchReading() {
    _futureReading = _service.fetchLastReading();
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildSensorCard(String title, String value, IconData icon, Color color) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2D3E),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor Ambiental'),
        backgroundColor: const Color(0xFF2A2D3E),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchReading),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1F38), Color(0xFF2A2D3E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<SensorReading>(
          future: _futureReading,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF2697FF)));
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lectura de: ${data.createdAt.toLocal()}', style: const TextStyle(color: Colors.white60)),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          _buildSensorCard('Temperatura', '${data.temperatura} °C', Icons.thermostat, Colors.orangeAccent),
                          _buildSensorCard('Humedad', '${data.humedad} %', Icons.water_drop, Colors.blueAccent),
                          _buildSensorCard('Humedad Suelo', '${data.humedadSuelo} %', Icons.grass, Colors.greenAccent),
                          _buildSensorCard('Calidad Aire', data.calidadAire, Icons.air, Colors.purpleAccent),
                          _buildSensorCard('Estado Temperatura', data.estadoTemperatura, Icons.device_thermostat, Colors.redAccent),
                          _buildSensorCard('Estado Humedad', data.estadoHumedad, Icons.opacity, Colors.cyanAccent),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2D3E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.water, color: Colors.lightBlueAccent),
                              SizedBox(width: 8),
                              Text('Estado del Agua', style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data.estadoAgua,
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('ID Sensor: ${data.id}', style: const TextStyle(color: Colors.white60)),
                  ],
                ),
              );
            }
            return const Center(child: Text('Sin datos', style: TextStyle(color: Colors.white60)));
          },
        ),
      ),
    );
  }
}
