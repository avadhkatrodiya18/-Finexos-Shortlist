import 'package:finexos/data/models/sensor_model.dart';
import 'package:finexos/data/services/mock_sensor_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:finexos/presentation/views/dashboard_view.dart';
import 'package:finexos/presentation/viewmodels/dashboard_viewmodel.dart';
import 'package:finexos/domain/repo/sensor_repository.dart';

class FakeSensorRepo implements SensorRepository {
  @override
  List<SensorModel> fetchSensors() => MockSensorService().getMockSensors();
}

void main() {
  setUp(() {
    Get.put<DashboardViewModel>(DashboardViewModel(FakeSensorRepo()));
  });

  testWidgets('DashboardView shows header and toggle buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: DashboardView(),
      ),
    );

    expect(find.text('Pulseboard Dashboard'), findsOneWidget);
    expect(find.text('Bubble Size by: '), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNWidgets(2));
  });

  testWidgets('Tapping on pressure chip updates selection', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(home: DashboardView()),
    );

    final pressureChip = find.widgetWithText(ChoiceChip, 'Pressure');
    expect(pressureChip, findsOneWidget);

    await tester.tap(pressureChip);
    await tester.pump();

    final viewModel = Get.find<DashboardViewModel>();
    expect(viewModel.metricType.value, MetricType.pressure);
  });
}
