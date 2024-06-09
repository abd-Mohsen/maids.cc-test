import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maids.cc_test/constants.dart';
import 'package:maids.cc_test/main.dart';
import 'package:maids.cc_test/providers/user_provider.dart';
import 'package:maids.cc_test/services/remote_services.dart';
import 'package:maids.cc_test/views/widgets/auth_field.dart';
import 'package:maids.cc_test/views/widgets/task_card.dart';
import 'package:provider/provider.dart';

import '../../models/task_model.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController todo = TextEditingController();
  //todo: take userId from currentUser

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool buttonPressed = false;

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

  Future<void> addTask() async {
    bool valid = formKey.currentState!.validate();
    buttonPressed = true;
    if (!valid) return;
    try {
      toggleLoading(true);
      TaskModel? newTask = await RemoteServices.addTask(
        todo.text,
        completed,
        Provider.of<UserProvider>(context, listen: false).currentUser!.id,
      ).timeout(kTimeOutDuration1);
      if (newTask == null) {
        print("error adding task, check your connection"); //todo: show dialog
      } else {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) => AlertDialog(
            title: const Text("added successfully"),
            content: TaskCard(task: newTask),
            actions: [
              TextButton(
                onPressed: () => navigatorKey.currentState!.pop(),
                child: Text("ok"),
              )
            ],
          ),
        );
      }
    } on TimeoutException {
      print("request timed out, check your connection"); //todo: show dialog
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
    return BottomSheet(
      showDragHandle: true,
      enableDrag: true,
      onClosing: () {},
      builder: (context) => Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                "Add a Task",
                style: tt.headlineLarge!.copyWith(color: cs.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: AuthField(
                controller: todo,
                label: 'todo',
                prefixIcon: Icon(Icons.menu_outlined),
                validator: (val) => validateInput(val!, 4, 500, ""),
                onChanged: (val) {
                  if (buttonPressed) formKey.currentState!.validate();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CheckboxListTile(
                value: completed,
                onChanged: (val) => setCompleted(),
                title: Text("completed"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: isLoading ? null : () => addTask(),
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
                            "Add",
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
