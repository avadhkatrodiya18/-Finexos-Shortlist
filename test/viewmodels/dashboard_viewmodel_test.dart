import 'package:finexos/data/services/mock_sensor_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:finexos/presentation/viewmodels/dashboard_viewmodel.dart';
import 'package:finexos/data/models/sensor_model.dart';
import 'package:finexos/domain/repo/sensor_repository.dart';

// class FakeSensorRepo implements SensorRepository {
//   @override
//   List<SensorModel> fetchSensors() {
//     return MockSensorService().getMockSensors();
//   }
// }
class FakeSensorRepo implements SensorRepository {
  @override
  List<SensorModel> fetchSensors() {
    return [
      SensorModel(id: 'offline_1', location: 'A', temperature: 30, humidity: 50, pressure: 1010, anomaly: 10),
      SensorModel(id: 'offline_2', location: 'B', temperature: 32, humidity: 60, pressure: 1020, anomaly: 20),
      SensorModel(id: 'online', location: 'C', temperature: 28, humidity: 45, pressure: 1005, anomaly: 5),
    ];
  }
}
void main() {
  late DashboardViewModel viewModel;

  setUp(() {
    Get.testMode = true;
    viewModel = DashboardViewModel(FakeSensorRepo());
  });

  test('initially loads sensors with anomaly simulation on', () {
    viewModel.loadSensors();
    expect(viewModel.sensors.isNotEmpty, true);
  });

  test('toggle metric updates the metric type', () {
    viewModel.toggleMetric(MetricType.pressure);
    expect(viewModel.metricType.value, MetricType.pressure);
  });

  test('simulateOffline disables some sensors', () {
    viewModel.simulateOffline.value = true;
    viewModel.loadSensors();

    final offlineCount = viewModel.sensors.where((s) => s.isOffline).length;
    expect(offlineCount > 0, true);
  });

  test('simulateAnomaly off sets all anomaly to 0', () {
    viewModel.simulateAnomaly.value = false;
    viewModel.loadSensors();

    final allZero = viewModel.sensors.every((s) => s.anomaly == 0 || s.anomaly == -1);
    expect(allZero, true);
  });


  test('loads sensors with simulation flags', () {
    viewModel.simulateOffline.value = true;
    viewModel.simulateAnomaly.value = false;

    viewModel.loadSensors(forceAllOffline: true);

    final offlineSensors = viewModel.sensors.where((s) => s.isOffline);
    final allAnomalyZero = viewModel.sensors.every(
          (s) => s.anomaly == 0 || s.anomaly == -1,
    );

    print('Offline count: ${offlineSensors.length}');
    print('Sensor states: ${viewModel.sensors.map((s) => {
      'id': s.id,
      'temp': s.temperature,
      'anomaly': s.anomaly
    })}');

    expect(offlineSensors.isNotEmpty, true);
    expect(allAnomalyZero, true);
  });

  test('metric type toggle changes observable value', () {
    viewModel.toggleMetric(MetricType.pressure);
    expect(viewModel.metricType.value, MetricType.pressure);
  });
}
