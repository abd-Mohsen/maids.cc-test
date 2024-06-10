import 'package:maids.cc_test/main.dart';
import 'package:maids.cc_test/models/task_model.dart';

class LocalServices {
  static List<TaskModel> loadTasks() {
    List<TaskModel> tasks = [];
    if (prefs.containsKey("tasks")) {
      tasks.addAll(taskModelFromJson(prefs.getString("tasks") ?? ""));
    }
    return tasks;
  }

  static void storeNewTasks(List<TaskModel> newTasks) {
    List<TaskModel> tasks = loadTasks();
    tasks.addAll(newTasks);
    prefs.setString("tasks", taskModelToJson(tasks));
  }

  static void replaceTasks(List<TaskModel> newTasks) {
    prefs.setString("tasks", taskModelToJson(newTasks));
  }
}
