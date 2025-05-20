import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FixedYAxisChart extends StatelessWidget {
  final List<FlSpot> spots = List.generate(
    100,
    (i) => FlSpot(i.toDouble(), (i * i % 50).toDouble()),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Trục Y đứng yên
        SizedBox(
          width: 40,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('60'),
              Text('45'),
              Text('30'),
              Text('15'),
              Text('0'),
            ],
          ),
        ),
        // Biểu đồ có thể trượt
        Expanded(
          child: InteractiveViewer(
            constrained: false,
            minScale: 1.0,
            maxScale: 5.0,
            scaleEnabled: true,
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(
              double.infinity,
            ), // tránh giới hạn
            child: SizedBox(
              width: 2000,
              height: 300,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 100,
                  minY: 0,
                  maxY: 60,
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 10),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      barWidth: 2,
                      color: Colors.blue,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
