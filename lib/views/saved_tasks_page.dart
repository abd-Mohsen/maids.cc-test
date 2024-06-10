import 'package:flutter/material.dart';
import 'package:maids.cc_test/services/local_services.dart';
import 'package:maids.cc_test/views/widgets/task_card.dart';

import '../models/task_model.dart';

class SavedTasksPage extends StatefulWidget {
  const SavedTasksPage({super.key});

  @override
  State<SavedTasksPage> createState() => _SavedTasksPageState();
}

class _SavedTasksPageState extends State<SavedTasksPage> {
  List<TaskModel> tasks = [];

  @override
  void initState() {
    tasks = LocalServices.loadTasks();
    super.initState();
  }

  void clearSavedTasks() {
    setState(() {
      LocalServices.replaceTasks([]);
      tasks = LocalServices.loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme tt = Theme.of(context).textTheme;
    ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: Text(
          "saved tasks",
          style: tt.headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: () => clearSavedTasks(),
            icon: Icon(Icons.delete),
          ),
        ],
        backgroundColor: cs.surface,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, i) => TaskCard(task: tasks[i]),
      ),
    );
  }
}
