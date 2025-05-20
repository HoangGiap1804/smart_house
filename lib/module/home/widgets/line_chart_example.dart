import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartSample extends StatelessWidget {
  const LineChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: SizedBox(
      width: 1500, // đủ rộng để có thể scroll theo trục X
      height: 300, // chiều cao biểu đồ
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
          ),
          minX: 0,
          maxX: 13, // hoặc lớn hơn tùy dữ liệu
          minY: 0,
          maxY: 6,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, interval: 1),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, interval: 1),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 1,
            verticalInterval: 1,
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 1),
                FlSpot(1, 3),
                FlSpot(2, 2),
                FlSpot(3, 5),
                FlSpot(4, 3.1),
                FlSpot(5, 4),
                FlSpot(6, 3),
                FlSpot(7, 1),
                FlSpot(8, 3),
                FlSpot(9, 2),
                FlSpot(10, 5),
                FlSpot(11, 3.1),
                FlSpot(12, 4),
                FlSpot(13, 3),
              ],
              isCurved: true,
              barWidth: 4,
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ),
              belowBarData: BarAreaData(
                show: true,
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
