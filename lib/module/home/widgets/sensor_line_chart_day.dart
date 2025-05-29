import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_house/module/home/widgets/sensor_data.dart';
import 'package:smart_house/module/home/widgets/sensor_day.dart';

class SensorLineChartDay extends StatelessWidget {
  final List<SensorDay> data;
  final String unit;
  final int maxX;

  SensorLineChartDay({
    required this.data,
    required this.unit,
    required this.maxX,
  });

  List<FlSpot> _mapToSpots(List<SensorDay> data, String field) {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      final d = entry.value;

      switch (field) {
        case 'temperature':
          return FlSpot(d.hour.toDouble(), d.temperature);
        case 'humidity':
          return FlSpot(d.hour.toDouble(), d.humidity);
        case 'ppm':
          return FlSpot(d.hour.toDouble(), d.ppm);
        default:
          return FlSpot(d.hour.toDouble(), 0);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade100],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          // Chart
          Expanded(
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      final minute = touchedSpots.first.x.toInt();
                      double? temperature, humidity, ppm;

                      for (var spot in touchedSpots) {
                        switch (spot.barIndex) {
                          case 0:
                            temperature = spot.y;
                            break;
                          case 1:
                            humidity = spot.y;
                            break;
                          case 2:
                            ppm = spot.y;
                            break;
                        }
                      }

                      List<String> text = [
                        '$unit: $minute\ntemperature: ${temperature?.toStringAsFixed(1) ?? '-'}',
                        'humidity: ${humidity?.toStringAsFixed(1) ?? '-'}',
                        'ppm: ${ppm?.toStringAsFixed(1) ?? '-'}',
                      ];
                      int index = 0;
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          text[index++],
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
                lineBarsData: [
                  _buildLine(data, 'temperature', Colors.redAccent),
                  _buildLine(data, 'humidity', Colors.blueAccent),
                  _buildLine(data, 'ppm', Colors.green),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= maxX) return SizedBox();
                        return RotatedBox(
                          quarterTurns:
                              1, // Xoay 90 độ ngược chiều kim đồng hồ (1 = 90°, 2 = 180°, 3 = 270°)
                          child: Text(
                            index.toString(),
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 100,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  verticalInterval: 1,
                  getDrawingHorizontalLine:
                      (value) =>
                          FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                  getDrawingVerticalLine:
                      (value) =>
                          FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                minX: 0,
                maxX: maxX.toDouble(),
              ),
            ),
          ),

          // Legend
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.redAccent, 'Temperature'),
                SizedBox(width: 16),
                _buildLegendItem(Colors.blueAccent, 'Humidity'),
                SizedBox(width: 16),
                _buildLegendItem(Colors.green, 'PPM'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _buildLine(List<SensorDay> data, String field, Color color) {
    return LineChartBarData(
      spots: _mapToSpots(data, field),
      isCurved: false,
      gradient: LinearGradient(colors: [color.withOpacity(0.7), color]),
      barWidth: 3,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
