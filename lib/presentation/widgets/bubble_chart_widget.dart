import 'package:finexos/utils/color_utils.dart';
import 'package:finexos/utils/string_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/sensor_model.dart';
import '../viewmodels/dashboard_viewmodel.dart';

class BubbleChartWidget extends StatelessWidget {
  final RxList<SensorModel> sensors;
  final Rx<MetricType> metricType;
  final Function(SensorModel)? onBubbleTap;

  const BubbleChartWidget({
    super.key,
    required this.sensors,
    required this.metricType,
    this.onBubbleTap,
  });

  Color _getColor(int? anomaly) {
    if (anomaly == null || anomaly == -1) return ColorsUtils.grey;
    if (anomaly == 0) return ColorsUtils.green;
    if (anomaly <= 50) return ColorsUtils.yellow;
    return ColorsUtils.red;
  }

  double _getBubbleSize(SensorModel sensor) {
    if (sensor.isOffline) return 6;

    final value = metricType.value == MetricType.humidity
        ? sensor.humidity ?? 0
        : sensor.pressure ?? 0;

    return 6 + ((value.clamp(40, 100) - 40) / 60) * 14;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (sensors.isEmpty) {
        return const Center(child: Text(StringUtils.noSensorDataMessage));
      }

      final validTemps = sensors
          .where((s) => s.temperature != null)
          .map((s) => s.temperature!)
          .toList();

      double minY = 0;
      double maxTemp = validTemps.reduce((a, b) => a > b ? a : b);
      double maxY = ((maxTemp + 10) / 25).ceil() * 25;

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        color: ColorsUtils.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                StringUtils.sensorBubbleChart,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GestureDetector(
                  onTapUp: (details) {
                    final tapX = details.localPosition.dx;
                    final width = MediaQuery.of(context).size.width;
                    final index = ((tapX / width) * sensors.length).floor();
                    if (index >= 0 && index < sensors.length) {
                      onBubbleTap?.call(sensors[index]);
                    }
                  },
                  child: ScatterChart(
                    ScatterChartData(
                      minX: -1,
                      maxX: sensors.length.toDouble(),
                      minY: minY,
                      maxY: maxY,
                      scatterTouchData: ScatterTouchData(
                        enabled: true,
                        handleBuiltInTouches: true,
                        touchTooltipData: ScatterTouchTooltipData(
                          tooltipBgColor: ColorsUtils.white,
                          tooltipRoundedRadius: 8,
                          tooltipPadding: const EdgeInsets.all(12),
                          tooltipBorder: BorderSide(color: ColorsUtils.primaryColor, width: 1.5),
                          getTooltipItems: (ScatterSpot spot) {
                            final index = spot.x.toInt();
                            if (index >= 0 && index < sensors.length) {
                              final sensor = sensors[index];

                              return ScatterTooltipItem(
                                '',
                                textStyle: const TextStyle(fontSize: 0),
                                children: [
                                  const TextSpan(
                                    text: StringUtils.location,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorsUtils.primaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${sensor.location}\n',
                                    style: const TextStyle(fontSize: 12, color: ColorsUtils.black87),
                                  ),
                                  const TextSpan(
                                    text: StringUtils.temp,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorsUtils.deepOrange,
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${sensor.temperature==null?0:sensor.temperature?.toStringAsFixed(1)}°C',
                                    style: const TextStyle(fontSize: 12, color: ColorsUtils.black87),
                                  ),
                                ],
                              );
                            }
                            return null;
                          },
                        ),
                      ),

                      scatterSpots: List.generate(
                        sensors.length,
                            (index) {
                          final s = sensors[index];
                          return ScatterSpot(
                            index.toDouble(),
                            s.temperature ?? minY,
                            radius: _getBubbleSize(s),
                            color: _getColor(s.anomaly),
                          );
                        },
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: ColorsUtils.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, _) {
                              final i = value.toInt();
                              if (i >= 0 && i < sensors.length) {
                                return Text(
                                  sensors[i].location,
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 25,
                            reservedSize: 40,
                            getTitlesWidget: (value, _) {
                              return Text(
                                '${value.toInt()}°C',
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          left: BorderSide(color: ColorsUtils.grey, width: 1),
                          bottom: BorderSide(color: ColorsUtils.grey, width: 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _LegendItem(color: ColorsUtils.green, label: '0%'),
                  _LegendItem(color: ColorsUtils.yellow, label: '1–50%'),
                  _LegendItem(color: ColorsUtils.red, label: '51–100%'),
                  _LegendItem(color: ColorsUtils.grey, label: StringUtils.offline),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                StringUtils.yAxisTemperature,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
