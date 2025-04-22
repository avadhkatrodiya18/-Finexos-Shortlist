import 'package:finexos/utils/color_utils.dart';
import 'package:finexos/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../viewmodels/dashboard_viewmodel.dart';
import '../widgets/bubble_chart_widget.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final DashboardViewModel viewModel = Get.find<DashboardViewModel>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (kIsWeb && (screenWidth < 700 || screenHeight < 500)) {
      return Scaffold(
        appBar: AppBar(title: const Text(StringUtils.dashboardTitle)),
        body: const Center(
          child: Text(
            StringUtils.expandBrowserMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(StringUtils.dashboardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
              () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                StringUtils.sensorOverview,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(StringUtils.bubbleSizeBy),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text(StringUtils.humidityChoiceLabel),
                    selected:
                    viewModel.metricType.value == MetricType.humidity,
                    onSelected: (_) =>
                        viewModel.toggleMetric(MetricType.humidity),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text(StringUtils.pressureChoiceLabel),
                    selected:
                    viewModel.metricType.value == MetricType.pressure,
                    onSelected: (_) =>
                        viewModel.toggleMetric(MetricType.pressure),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                         Text(
                          StringUtils.tapBubbleForMetrics,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: ColorsUtils.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          StringUtils.tapXAxisForSensorDetails
                         ,
                          style:
                          TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: BubbleChartWidget(
                            sensors: viewModel.sensors,
                            metricType: viewModel.metricType,
                            onBubbleTap: (sensor) {
                              Get.toNamed('/details', arguments: sensor);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
