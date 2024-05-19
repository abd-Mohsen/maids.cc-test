import 'package:bloc/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("available courses"),
        actions: [
          IconButton(
            onPressed: () {
              navigatorKey.currentState!.pushNamedAndRemoveUntil("/home", (route) => false);
            },
            icon: Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(builder: (_, taskProvider, child) {
        return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, i) {
              var task = taskProvider.tasks[i];
              return ListTile(
                title: Text(task.todo),
                subtitle: Text(task.),
                leading: Image.asset("assets/images/flutter.png"),
              );
            });
      }),
    );
  }
}
