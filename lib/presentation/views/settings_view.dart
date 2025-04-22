import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/dashboard_viewmodel.dart';

class SettingsView extends StatelessWidget {
  final DashboardViewModel viewModel = Get.find<DashboardViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Obx(() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Simulate Sensor Conditions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          SwitchListTile(
            title: const Text("Simulate Offline Sensors"),
            value: viewModel.simulateOffline.value,
            onChanged: (val) {
              viewModel.simulateOffline.value = val;
              viewModel.loadSensors();
            },
          ),
          const SizedBox(height: 10),

          SwitchListTile(
            title: const Text("Randomize Anomalies"),
            value: viewModel.simulateAnomaly.value,
            onChanged: (val) {
              viewModel.simulateAnomaly.value = val;
              viewModel.loadSensors();
            },
          ),
        ],
      )),
    );
  }
}
