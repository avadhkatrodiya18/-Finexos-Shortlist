import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:finexos/presentation/widgets/bubble_chart_widget.dart';
import 'package:finexos/data/models/sensor_model.dart';
import 'package:finexos/presentation/viewmodels/dashboard_viewmodel.dart';

void main() {
  final sensors = <SensorModel>[
    SensorModel(
      id: '1',
      location: 'Line A',
      temperature: 35,
      humidity: 50,
      pressure: 1010,
      anomaly: 0,
    ),
  ].obs;

  testWidgets('renders bubble chart with a sensor', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BubbleChartWidget(
            sensors: sensors,
            metricType: MetricType.humidity.obs,
            onBubbleTap: (_) {},
          ),
        ),
      ),
    );

    expect(find.byType(BubbleChartWidget), findsOneWidget);
    expect(find.text('Sensor Bubble Chart'), findsOneWidget);
    expect(find.textContaining('Line A'), findsWidgets);
  });
}
