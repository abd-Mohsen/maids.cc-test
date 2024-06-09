import 'package:flutter/material.dart';
import 'package:maids.cc_test/models/task_model.dart';

class TaskPage extends StatelessWidget {
  final TaskModel task;
  const TaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    TextTheme tt = Theme.of(context).textTheme;
    ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: Text("view task"),
        backgroundColor: cs.surface,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("todo"),
            subtitle: Text(task.todo),
          ),
          ListTile(
            title: Text("completed"),
            subtitle: Text(task.completed.toString()),
          ),
          ListTile(
            title: Text("owner id"),
            subtitle: Text(task.userId.toString()),
          ),
        ],
      ),
    );
  }
}
