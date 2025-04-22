import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StyledLineChart extends StatelessWidget {
  final List<FlSpot> dataPoints;
  final double minY;
  final double maxY;

  const StyledLineChart({
    super.key,
    required this.dataPoints,
    this.minY = 0,
    this.maxY = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              getTouchedSpotIndicator: (barData, spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    FlLine(color: Colors.transparent),
                    FlDotData(show: false),
                  );
                }).toList();
              },              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.indigo.withOpacity(0.9),
                tooltipRoundedRadius: 8,
                fitInsideHorizontally: true,
                fitInsideVertically: true,
              getTooltipItems: (touchedSpots) {
                if (touchedSpots.isEmpty) return [];

                return touchedSpots.map((spot) {
                  final hour = 8 + spot.x.toInt();
                  final y = spot.y.toStringAsFixed(2);

                  return LineTooltipItem(
                    '🕒 Time: $hour:00\n🌡️ Temp: $y °C',
                    const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  );
                }).toList();
              },
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 20,
                  reservedSize: 42,
                  getTitlesWidget: (value, _) => Text(
                    '${value.toInt()}°',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, _) {
                    final hour = 8 + value.toInt();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '$hour:00',
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 20,
              getDrawingHorizontalLine: (_) => FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
              ),
              getDrawingVerticalLine: (_) => FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Colors.grey, width: 1),
                bottom: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints,
                isCurved: true,
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.blueAccent],
                ),
                barWidth: 3,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigo.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                dotData: FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
