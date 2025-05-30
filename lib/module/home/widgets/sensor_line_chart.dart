import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_house/module/home/widgets/sensor_data.dart';

class SensorLineChart extends StatelessWidget {
  final List<SensorData> data;

  SensorLineChart({required this.data});

  List<FlSpot> _mapToSpots(List<SensorData> data, String field) {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      final d = entry.value;

      switch (field) {
        case 'temperature':
          return FlSpot(index.toDouble(), d.temperature);
        case 'humidity':
          return FlSpot(index.toDouble(), d.humidity);
        case 'ppm':
          return FlSpot(index.toDouble(), d.ppm);
        default:
          return FlSpot(index.toDouble(), 0);
      }
    }).toList();
  }

  List<String> _getTimeLabels(List<SensorData> data) {
    return data.map((e) => DateFormat.Hm().format(e.time)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final timeLabels = _getTimeLabels(data);

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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Chart
          Expanded(
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  _buildLine(data, 'temperature', Colors.redAccent),
                  _buildLine(data, 'humidity', Colors.blueAccent),
                  _buildLine(data, 'ppm', Colors.green),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= timeLabels.length) return Container();
                        return Text(timeLabels[index], style: TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
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
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                minX: 0,
                maxX: data.length.toDouble() - 1,
              ),
            ),
          ),

          // Legend
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.redAccent, 'Nhiệt độ'),
                SizedBox(width: 16),
                _buildLegendItem(Colors.blueAccent, 'Độ ẩm'),
                SizedBox(width: 16),
                _buildLegendItem(Colors.green, 'Khí PPM'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _buildLine(List<SensorData> data, String field, Color color) {
    return LineChartBarData(
      spots: _mapToSpots(data, field),
      isCurved: true,
      gradient: LinearGradient(
        colors: [color.withOpacity(0.7), color],
      ),
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
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
