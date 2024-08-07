import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/utils/colors.dart';
import 'package:task_management/view_models/task/to_do_provider.dart';
import 'package:task_management/views/task/task_list.dart';

void main() {
  runApp(const TaskManagement());
}

class TaskManagement extends StatelessWidget {
  const TaskManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Management',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.appColor),
          useMaterial3: true,
        ),
        home: const TaskList(),
      ),
    );
  }
}
