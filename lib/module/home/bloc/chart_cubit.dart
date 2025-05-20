import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  ChartCubit() : super(ChartInital());

  Future<void> loadChartData(List<FlSpot> list, int index) async {
    emit(ChartLoading(list: list, index: index));
  }

  Future<void> changeChart(int index) async {
    emit(ChartChanged(index: index));
  }

}
