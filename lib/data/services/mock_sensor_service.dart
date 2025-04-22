import 'dart:math';
import 'package:finexos/data/models/sensor_model.dart';

class MockSensorService {
  final Random _random = Random();

  List<SensorModel> getMockSensors() {
    final List<String> locations = ['Line A', 'Line B', 'Line C', 'Line D'];

    return List.generate(locations.length, (index) {
      final isOffline = _random.nextBool() && index % 3 == 0;

      return SensorModel(
        id: 'sensor_$index',
        location: locations[index],
        temperature: isOffline ? null : _random.nextDouble() * 40 + 20,
        humidity: isOffline ? null : _random.nextDouble() * 40 + 40,
        pressure: isOffline ? null : 900 + _random.nextDouble() * 200,
        anomaly: isOffline ? -1 : _random.nextInt(101),
      );
    });
  }
}
