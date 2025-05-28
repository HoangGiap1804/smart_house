import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_house/module/home/bloc/chart_cubit.dart';
import 'package:smart_house/module/home/widgets/button_action.dart';
import 'package:smart_house/module/home/widgets/line_chart_example.dart';
import 'package:smart_house/module/home/widgets/my_drawer.dart';
import 'package:smart_house/module/home/widgets/zoomable_line_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbRef = FirebaseDatabase.instance.ref();
  double indexTem = 0;
  double indexHum = 0;
  double indexPPM = 0;
  final List<FlSpot> spotsTem = [];
  final List<FlSpot> spotsHum = [];
  final List<FlSpot> spotsPPM = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder(
                  stream: dbRef.child('Sensor/temperature').onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.snapshot.value != null) {
                      final data = snapshot.data!.snapshot.value as num;
                      double value = data.toDouble();
                      spotsTem.add(FlSpot(indexTem++, value));
                      GetIt.instance<ChartCubit>().loadChartData(spotsTem, 0);
                      return ButtonAction(
                        text: "$data°C",
                        onTap: () {
                          GetIt.instance<ChartCubit>().changeChart(0);
                        },
                      );
                    } else {
                      return Text("Loading...");
                    }
                  },
                ),
                StreamBuilder(
                  stream: dbRef.child('Sensor/humidity').onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.snapshot.value != null) {
                      final data = snapshot.data!.snapshot.value as num;
                      double value = (data).toDouble();
                      spotsHum.add(FlSpot(indexHum++, value));
                      GetIt.instance<ChartCubit>().loadChartData(spotsHum, 1);
                      return ButtonAction(
                        text: "Humidity $data%",
                        onTap: () {
                          GetIt.instance<ChartCubit>().changeChart(1);
                        },
                      );
                    } else {
                      return Text("Loading...");
                    }
                  },
                ),
                StreamBuilder(
                  stream: dbRef.child('Sensor/PPM').onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.snapshot.value != null) {
                      final data = snapshot.data!.snapshot.value as num;
                      double value = (data).toDouble();
                      spotsPPM.add(FlSpot(indexPPM++, value));
                      GetIt.instance<ChartCubit>().loadChartData(spotsPPM, 2);
                      return ButtonAction(
                        text: "PPM $data",
                        onTap: () {
                          GetIt.instance<ChartCubit>().changeChart(2);
                        },
                      );
                    } else {
                      return Text("Loading...");
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 50),
            Center(
              child: SizedBox(
                height: 300,
                width: 400,
                child: ZoomableLineChart(),
              ),
            ),
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StreamBuilder(
                  stream: dbRef.child('control/auto').onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.snapshot.value != null) {
                      final data = snapshot.data!.snapshot.value as bool;
                      final isAuto = data == true;
                      return ButtonAction(
                        text: "Auto $data",
                        colorsLinear:
                            (isAuto)
                                ? [Color(0xFFa8e063), Color(0xFF56ab2f)]
                                : [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                        onTap: () {
                          dbRef.child('control/auto').set(!isAuto);
                          dbRef.child('control/blow').set(0);
                        },
                      );
                    } else {
                      return Text("Loading...");
                    }
                  },
                ),
                SizedBox(height: 10),
                StreamBuilder(
                  stream: dbRef.child('control/blow').onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.snapshot.value != null) {
                      final data = snapshot.data!.snapshot.value as num;
                      final blow = data;
                      return ButtonAction(
                        text: "Blow in",
                        colorsLinear:
                            (blow == 1)
                                ? [Color(0xFFa8e063), Color(0xFF56ab2f)]
                                : [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                        onTap: () {
                          (blow != 1)
                              ? dbRef.child('control/blow').set(1)
                              : dbRef.child('control/blow').set(0);

                          dbRef.child('control/auto').set(false);
                        },
                      );
                    } else {
                      return Text("Loading...");
                    }
                  },
                ),
                SizedBox(height: 10),
                StreamBuilder(
                  stream: dbRef.child('control/blow').onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.snapshot.value != null) {
                      final data = snapshot.data!.snapshot.value as num;
                      return ButtonAction(
                        text: "Blow out",
                        colorsLinear:
                            (data == 2)
                                ? [Color(0xFFa8e063), Color(0xFF56ab2f)]
                                : [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                        onTap: () {
                          (data != 2)
                              ? dbRef.child('control/blow').set(2)
                              : dbRef.child('control/blow').set(0);

                          dbRef.child('control/auto').set(false);
                        },
                      );
                    } else {
                      return Text("Loading...");
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
