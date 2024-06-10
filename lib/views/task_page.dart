import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maids.cc_test/models/task_model.dart';
import 'package:maids.cc_test/views/widgets/update_task_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../main.dart';
import '../providers/task_provider.dart';
import '../services/remote_services.dart';

class TaskPage extends StatefulWidget {
  final TaskModel task;
  const TaskPage({super.key, required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  Future<void> deleteTask() async {
    try {
      toggleLoading(true);
      if (widget.task.id != 255) {
        bool deleted = await RemoteServices.deleteTask(
          widget.task.id,
        ).timeout(kTimeOutDuration2);
        if (!deleted) {
          showDialog(
            context: navigatorKey.currentContext!,
            builder: (context) => kCheckConnectionDialog,
          );
          throw Exception("connection error");
        }
      }
      Provider.of<TaskProvider>(navigatorKey.currentContext!, listen: false).deleteTask(widget.task);
      navigatorKey.currentState!.pop();
      navigatorKey.currentState!.pop();
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text("deleted successfully"),
          actions: [
            TextButton(
              onPressed: () => navigatorKey.currentState!.pop(),
              child: const Text("ok"),
            )
          ],
        ),
      );
    } on TimeoutException {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => kTimeoutDialog,
      );
    } catch (e) {
      print(e.toString());
    } finally {
      toggleLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme tt = Theme.of(context).textTheme;
    ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: Text(
          "view task",
          style: tt.headlineMedium,
        ),
        backgroundColor: cs.surface,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.menu_outlined),
            title: Text(
              "todo",
              style: tt.titleLarge,
            ),
            subtitle: Text(
              widget.task.todo,
              style: tt.titleMedium,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.task_alt),
            title: Text(
              "completed",
              style: tt.titleLarge,
            ),
            subtitle: Text(
              widget.task.completed.toString(),
              style: tt.titleMedium,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_2_outlined),
            title: Text(
              "owner id",
              style: tt.titleLarge,
            ),
            subtitle: Text(
              widget.task.userId.toString(),
              style: tt.titleMedium,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => UpdateTaskBottomSheet(task: widget.task),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "update",
                  style: tt.titleLarge,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("do you want to delete this task?"),
                    actions: [
                      TextButton(
                        onPressed: () => deleteTask(),
                        child: const Text("yes"),
                      ),
                      TextButton(
                        onPressed: () => navigatorKey.currentState!.pop(),
                        child: const Text("no"),
                      ),
                    ],
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "delete",
                  style: tt.titleLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
