import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/dashboard_viewmodel.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final DashboardViewModel viewModel = Get.find<DashboardViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pulseboard Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sensor Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("Bubble Size by: "),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("Humidity"),
                  selected: viewModel.metricType.value == MetricType.humidity,
                  onSelected: (_) => viewModel.toggleMetric(MetricType.humidity),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("Pressure"),
                  selected: viewModel.metricType.value == MetricType.pressure,
                  onSelected: (_) => viewModel.toggleMetric(MetricType.pressure),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.sensors.length,
                itemBuilder: (context, index) {
                  final sensor = viewModel.sensors[index];
                  return Card(
                    child: ListTile(
                      title: Text(sensor.location),
                      subtitle: Text(
                        sensor.isOffline
                            ? "Status: Offline"
                            : "Temp: ${sensor.temperature?.toStringAsFixed(1)}°C | Anomaly: ${sensor.anomaly}%",
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => Get.toNamed('/details', arguments: sensor),
                    ),
                  );
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}
