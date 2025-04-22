import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/sensor_model.dart';
import '../viewModels/dashboard_viewmodel.dart';


class BubbleChartWidget extends StatelessWidget {
  final RxList<SensorModel> sensors;
  final Rx<MetricType> metricType;

  const BubbleChartWidget({
    super.key,
    required this.sensors,
    required this.metricType,
  });

  Color _getColor(int? anomaly) {
    if (anomaly == null || anomaly == -1) return Colors.grey;
    if (anomaly == 0) return Colors.green;
    if (anomaly <= 50) return Colors.yellow;
    return Colors.red;
  }

  double _getBubbleSize(SensorModel sensor) {
    if (sensor.isOffline) return 6;

    final double value = metricType.value == MetricType.humidity
        ? sensor.humidity ?? 0
        : sensor.pressure ?? 0;

    // Normalize sizes between 6–20
    if (metricType.value == MetricType.humidity) {
      return 6 + ((value.clamp(40, 100) - 40) / 60) * 14;
    } else {
      return 6 + ((value.clamp(900, 1100) - 900) / 200) * 14;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (sensors.isEmpty) {
        return const Center(child: Text('No data available.'));
      }

      return ScatterChart(
        ScatterChartData(
          scatterSpots: List.generate(
            sensors.length,
                (index) {
              final s = sensors[index];
              return ScatterSpot(
                index.toDouble(), // X: location index
                s.temperature ?? 0, // Y: temperature
                color: _getColor(s.anomaly),
                radius: _getBubbleSize(s),
              );
            },
          ),
          minX: -1,
          maxX: sensors.length.toDouble(),
          minY: 0,
          maxY: 100,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i >= 0 && i < sensors.length) {
                    return Text(sensors[i].location);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, interval: 10),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      );
    });
  }
}
