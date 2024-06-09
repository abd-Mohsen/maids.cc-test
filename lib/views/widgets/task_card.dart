import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    TextTheme tt = Theme.of(context).textTheme;
    ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(task.todo, overflow: TextOverflow.ellipsis, maxLines: 2),
        //subtitle: Text(task.a),
        leading: Icon(task.completed ? Icons.task_alt : Icons.close),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: cs.onBackground.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(5),
        ),
        onTap: () {
          navigatorKey.currentState!.pushNamed("/task", arguments: task);
        },
      ),
    );
  }
}
