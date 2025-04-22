import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/sensor_model.dart';

class DetailsView extends StatelessWidget {
  DetailsView({super.key});

  final SensorModel sensor = Get.arguments as SensorModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details - ${sensor.location}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sensor ID: ${sensor.id}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Temperature: ${sensor.temperature?.toStringAsFixed(1) ?? 'N/A'}°C"),
            Text("Humidity: ${sensor.humidity?.toStringAsFixed(1) ?? 'N/A'}%"),
            Text("Pressure: ${sensor.pressure?.toStringAsFixed(1) ?? 'N/A'} hPa"),
            Text("Anomaly: ${sensor.anomaly == -1 ? 'Offline' : '${sensor.anomaly}%'}"),
            const SizedBox(height: 20),
            const Text("Chart coming soon..."),
          ],
        ),
      ),
    );
  }
}
