import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_house/module/home/widgets/button_action.dart';
import 'package:smart_house/module/home/widgets/my_drawer.dart';
import 'package:smart_house/module/home/widgets/sensor_data.dart';
import 'package:smart_house/module/home/widgets/sensor_day.dart';
import 'package:smart_house/module/home/widgets/sensor_line_chart_day.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime selectedDate = DateTime.now();

  final List<SensorData> data = [];

  // Hàm mở DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      // Gọi API hoặc load dữ liệu theo ngày ở đây
      print("Ngày được chọn: ${DateFormat('dd/MM/yyyy').format(selectedDate)}");
    }
  }

  Future<List<SensorDay>>? fetchSensorData() async {
    final firestore = FirebaseFirestore.instance;
    final docSnapshot =
        await firestore
            .collection('data')
            .doc(DateFormat('yyyy_MM_dd').format(selectedDate).toString())
            .get();
    print("day picked");
    print(DateFormat('yyyy_MM_dd').format(selectedDate));

    if (!docSnapshot.exists) return [];

    final data = docSnapshot.data();
    if (data == null || data.isEmpty) return [];

    List<SensorDay> sensorList = [];

    // Lặp qua từng giờ
    for (final entry in data.entries) {
      final hour = int.tryParse(entry.key);
      print("Key hour $hour");
      final rawValue = entry.value.toString().split(',');

      if (hour != null && rawValue.length == 3) {
        final temperature = double.tryParse(rawValue[0].trim());
        final humidity = double.tryParse(rawValue[1].trim());
        final ppm = double.tryParse(rawValue[2].trim());

        if (temperature != null && humidity != null && ppm != null) {
          sensorList.add(
            SensorDay(
              hour: hour,
              temperature: temperature,
              humidity: humidity,
              ppm: ppm,
            ),
          );
        }
      }
    }

    // Sắp xếp theo giờ
    sensorList.sort((a, b) => a.hour.compareTo(b.hour));
    return sensorList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HISTORY')),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Nút chọn ngày
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ButtonAction(
                  text: "Select day",
                  onTap: () => _selectDate(context),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Dữ liệu lịch sử theo ngày sẽ được hiển thị ở đây
            // Expanded(
            //   child: Center(
            //     child: SizedBox(
            //       height: 400,
            //       child: SensorLineChart(data: data),
            //     ),
            //   ),
            // ),
            FutureBuilder<List<SensorDay>>(
              future: fetchSensorData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No data found');
                }

                final data = snapshot.data!;
                return Expanded(
                  child: Center(
                    child: SizedBox(
                      height: 400,
                      child: SensorLineChartDay(
                        data: data,
                        unit: "Hour",
                        maxX: 24,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
