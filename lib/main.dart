import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_house/firebase_options.dart';
import 'package:smart_house/module/home/bloc/chart_cubit.dart';
import 'package:smart_house/module/home/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  GetIt.instance.registerSingleton<ChartCubit>(ChartCubit());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ChartCubit>(),
      child: MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen())
    );
  }
}
