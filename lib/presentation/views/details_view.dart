import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../../../data/models/sensor_model.dart';
import '../widgets/detail_view_graph.dart';

class DetailsView extends StatelessWidget {
  DetailsView({super.key});

  final SensorModel sensor = Get.arguments as SensorModel;

  @override
  Widget build(BuildContext context) {
    final temp = sensor.temperature ?? 25;

    return Scaffold(
      appBar: AppBar(
        title: Text('Details - ${sensor.location}'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sensor Info Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("📟 Sensor ID", sensor.id),
                  _buildInfoRow("🌡️ Temperature", "${sensor.temperature?.toStringAsFixed(1) ?? 'N/A'} °C"),
                  _buildInfoRow("💧 Humidity", "${sensor.humidity?.toStringAsFixed(1) ?? 'N/A'}%"),
                  _buildInfoRow("🌬️ Pressure", "${sensor.pressure?.toStringAsFixed(1) ?? 'N/A'} hPa"),
                  _buildInfoRow("🚨 Anomaly", sensor.anomaly == -1 ? 'Offline' : '${sensor.anomaly}%'),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Chart Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "📈 Hourly Temperature (08:00–18:00)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Chart
            SizedBox(
              height: 220,
              child: StyledLineChart(
                dataPoints: List.generate(
                  11,
                      (i) => FlSpot(i.toDouble(), temp + (i % 3 - 1) * 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
        ],
      ),
    );
  }
}
