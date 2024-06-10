import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maids.cc_test/constants.dart';
import 'package:maids.cc_test/main.dart';
import 'package:maids.cc_test/providers/task_provider.dart';
import 'package:maids.cc_test/services/remote_services.dart';
import 'package:maids.cc_test/views/widgets/task_card.dart';
import 'package:provider/provider.dart';

import '../../models/task_model.dart';

class UpdateTaskBottomSheet extends StatefulWidget {
  final TaskModel task;
  const UpdateTaskBottomSheet({super.key, required this.task});

  @override
  State<UpdateTaskBottomSheet> createState() => _UpdateTaskBottomSheetState();
}

class _UpdateTaskBottomSheetState extends State<UpdateTaskBottomSheet> {
  @override
  void initState() {
    completed = widget.task.completed;
    super.initState();
  }

  bool completed = false;
  void setCompleted() {
    setState(() {
      completed = !completed;
    });
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  Future<void> updateTask() async {
    try {
      toggleLoading(true);
      TaskModel? updatedTask;
      if (widget.task.id == 255) {
        //because i cant edit a task unless it is in the server (fake api)
        widget.task.completed == completed;
        updatedTask = widget.task;
      } else {
        updatedTask = await RemoteServices.updateTask(
          widget.task.id,
          completed,
        ).timeout(kTimeOutDuration1);
      }
      if (updatedTask == null) {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) => kCheckConnectionDialog,
        );
      } else {
        Provider.of<TaskProvider>(navigatorKey.currentContext!, listen: false).updateTask(widget.task, completed);
        navigatorKey.currentState!.pop();
        navigatorKey.currentState!.pop();
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) => AlertDialog(
            title: const Text("updated successfully"),
            content: TaskCard(task: updatedTask!),
            actions: [
              TextButton(
                onPressed: () => navigatorKey.currentState!.pop(),
                child: const Text("ok"),
              )
            ],
          ),
        );
      }
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
    return SizedBox(
      height: 300,
      child: BottomSheet(
        showDragHandle: true,
        enableDrag: true,
        onClosing: () {},
        builder: (context) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                "Update a Task",
                style: tt.headlineLarge!.copyWith(color: cs.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CheckboxListTile(
                value: completed,
                onChanged: (val) => setCompleted(),
                title: const Text("completed"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: isLoading ? null : () => updateTask(),
                child: Container(
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: isLoading
                        ? CircularProgressIndicator(color: cs.onPrimary)
                        : Text(
                            "Update",
                            style: tt.headlineMedium!.copyWith(color: cs.onPrimary),
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
