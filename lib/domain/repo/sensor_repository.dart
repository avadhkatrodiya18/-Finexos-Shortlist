import '../../data/models/sensor_model.dart';
import '../../data/services/mock_sensor_service.dart';

class SensorRepository {
  final MockSensorService _service;

  SensorRepository(this._service);

  List<SensorModel> fetchSensors() {
    return _service.getMockSensors();
  }
}
