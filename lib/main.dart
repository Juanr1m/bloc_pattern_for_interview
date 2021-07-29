import 'package:agrobank_test/bloc/tasks/task_bloc.dart';
import 'package:agrobank_test/repositories/db.dart';
import 'package:agrobank_test/repositories/models/task.dart';
import 'package:agrobank_test/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());
  await Hive.openBox<Task>('Task');
  runApp(
    BlocProvider(
      create: (context) => TaskBloc(TaskDatabase()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TaskBloc>(context).add(TaskInitialEvent());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bloc pattern demo for AgroBank',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
