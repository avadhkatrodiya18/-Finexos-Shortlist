import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data/services/mock_sensor_service.dart';
import 'domain/repo/sensor_repository.dart';
import 'presentation/viewmodels/dashboard_viewmodel.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';

void main() {
  // Register dependencies before app starts
  final sensorService = MockSensorService();
  final sensorRepo = SensorRepository(sensorService);
  Get.put(sensorRepo);
  Get.put(DashboardViewModel(sensorRepo)); // ViewModel as singleton

  runApp(const PulseboardApp());
}

class PulseboardApp extends StatelessWidget {
  const PulseboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pulseboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      getPages: AppPages.routes,
    );
  }
}
