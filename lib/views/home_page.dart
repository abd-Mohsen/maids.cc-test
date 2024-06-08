import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/task_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<TaskProvider>(context).getTasks();
    super.initState();
  }

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
                //subtitle: Text(task.a),
                leading: Icon(Icons.task_alt),
              );
            });
      }),
    );
  }
}
