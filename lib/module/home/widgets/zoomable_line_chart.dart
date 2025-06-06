import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_house/module/home/bloc/chart_cubit.dart';
import 'package:smart_house/module/home/bloc/chart_state.dart';

class ZoomableLineChart extends StatefulWidget {
  const ZoomableLineChart({super.key});
  @override
  _ZoomableLineChartState createState() => _ZoomableLineChartState();
}

class _ZoomableLineChartState extends State<ZoomableLineChart> {
  String text = "Temperature";
  List<FlSpot> spotsTem = [];
  List<FlSpot> spotsHumidity = [];
  List<FlSpot> spotsPPM = [];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChartCubit, ChartState>(
      listener: (context, state) {
        if (state is ChartLoading) {
          setState(() {
            switch (state.index) {
              case 0:
                spotsTem = state.list;
                break;
              case 1:
                spotsHumidity = state.list;
                break;
              case 2:
                spotsPPM = state.list;
                break;
              default:
            }
          });
        }
        if (state is ChartChanged) {
          setState(() {
            index = state.index;
            print("Co goi den day $index");
            switch (index) {
              case 0:
                text = "Temperature";
                break;
              case 1:
                text = "Humidity";
                break;
              case 2:
                text = "PPM";
                break;
              default:
            }
          });
        }
      },
      child: Column(
        children: [
          Text(text),
          SizedBox(
            height: 300,
            child: InteractiveViewer(
              // 👈 Zoom + scroll
              constrained: false,
              scaleEnabled: true,
              panEnabled: true,
              minScale: 1,
              maxScale: 5,
              child: SizedBox(
                width: 2000, // 👈 Chiều dài biểu đồ (có thể kéo)
                height: 300,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 
                  (index == 0)
                    ? (spotsTem.isNotEmpty) ? spotsTem.length + 10 : 100
                    : (index == 1)
                    ? (spotsHumidity.isNotEmpty) ? spotsHumidity.length + 10 : 100
                    : (spotsHumidity.isNotEmpty) ? spotsPPM.length + 100 : 100,
                    minY: 0,
                    maxY: 
                  (index == 0)
                    ? (spotsTem.isNotEmpty) ? spotsTem.reduce((a, b) => a.y > b.y ? a : b).y + 10 : 100
                    : (index == 1)
                    ? (spotsHumidity.isNotEmpty) ? spotsHumidity.reduce((a, b) => a.y > b.y ? a : b).y + 10 : 100
                    : (spotsHumidity.isNotEmpty) ? spotsPPM.reduce((a, b) => a.y > b.y ? a : b).y + 500 : 100,

                    lineTouchData: LineTouchData(enabled: true),
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          interval: 10
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          interval: 10
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: (index == 0)
                          ? 10
                          : (index == 1)
                          ? 10
                          : 100,

                          reservedSize: 40, // 👈 Chừa đủ không gian để label nằm gọn
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toStringAsFixed(0),
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.center, // 👈 đảm bảo canh giữa
                              overflow: TextOverflow.ellipsis, // 👈 tránh vỡ dòng
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots:
                      (index == 0)
                        ? spotsTem
                        : (index == 1)
                        ? spotsHumidity
                        : spotsPPM,
                        isCurved: false,
                        color: Colors.blue,
                        barWidth: 3,
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.red, Colors.blue],
                        ),
                        belowBarData: BarAreaData(show: true),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.blue, // ✅ màu cố định
                              strokeWidth: 1,
                              strokeColor: Colors.white, // viền trắng nếu cần
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
    ],
      )
    );
  }
}
