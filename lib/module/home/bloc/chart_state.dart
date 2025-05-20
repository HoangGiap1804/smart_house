import 'package:fl_chart/fl_chart.dart';

abstract class ChartState {}

class ChartInital extends ChartState {}

class ChartLoading extends ChartState {
  List<FlSpot> list;
  int index;

  ChartLoading({required this.list, required this.index});
}

class ChartChanged extends ChartState{
  int index;
  ChartChanged({required this.index});
}
