import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskati/feature/splash_screan/splash_view.dart';
import 'package:taskati/model/task_model.dart';

import 'utiles/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<Task>('task');
  await Hive.openBox<bool>('mode');
  await Hive.openBox('user');
   Hive.registerAdapter<Task>(TaskAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          color: Colors.transparent,
          iconTheme: IconThemeData(
            color: AppColors.primaryColor,
          ),
        ),
      ),
      home: SplashView(),
    );
  }
}
