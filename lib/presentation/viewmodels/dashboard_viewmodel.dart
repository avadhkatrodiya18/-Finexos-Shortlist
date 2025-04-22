import 'package:finexos/domain/repo/sensor_repository.dart';
import 'package:get/get.dart';
import '../../../data/models/sensor_model.dart';

enum MetricType { humidity, pressure }

class DashboardViewModel extends GetxController {
  final SensorRepository _repository;

  DashboardViewModel(this._repository);

  var sensors = <SensorModel>[].obs;
  var metricType = MetricType.humidity.obs;

  var simulateOffline = false.obs;
  var simulateAnomaly = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadSensors();
  }

  void loadSensors({bool forceAllOffline = false}) {
    final rawSensors = _repository.fetchSensors();

    final updatedSensors = rawSensors.map((sensor) {
      SensorModel s = sensor;

      if (!simulateAnomaly.value) {
        s = s.copyWith(anomaly: 0);
      }

      if (simulateOffline.value && (forceAllOffline || s.id.hashCode % 2 == 0)) {
        s = s.copyWith(
          temperature: null,
          humidity: null,
          pressure: null,
          anomaly: -1,
        );
      }

      return s;
    }).toList();

    sensors.value = updatedSensors;
  }

  void toggleMetric(MetricType type) {
    metricType.value = type;
  }
}
