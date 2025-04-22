import 'package:finexos/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/dashboard_viewmodel.dart';

class SettingsView extends StatelessWidget {
  final DashboardViewModel viewModel = Get.find<DashboardViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringUtils.settingsTitle),
      ),
      body: Obx(() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            StringUtils.simulateSensorConditions,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          SwitchListTile(
            title: const Text(StringUtils.simulateOfflineSensors),
            value: viewModel.simulateOffline.value,
            onChanged: (val) {
              viewModel.simulateOffline.value = val;
              viewModel.loadSensors();
            },
          ),
          const SizedBox(height: 10),

          SwitchListTile(
            title: const Text(StringUtils.randomizeAnomalies),
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
