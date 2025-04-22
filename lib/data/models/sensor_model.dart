class SensorModel {
  final String id;
  final String location;
  final double? temperature;
  final double? humidity;
  final double? pressure;
  final int? anomaly;

  SensorModel({
    required this.id,
    required this.location,
    this.temperature,
    this.humidity,
    this.pressure,
    this.anomaly,
  });

  bool get isOffline => anomaly == null || anomaly == -1;

  SensorModel copyWith({
    double? temperature,
    double? humidity,
    double? pressure,
    int? anomaly,
  }) {
    return SensorModel(
      id: id,
      location: location,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
      anomaly: anomaly ?? this.anomaly,
    );
  }
}
