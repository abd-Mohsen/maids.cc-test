import 'package:flutter/foundation.dart';

import '../models/task_model.dart';
import '../services/remote_services.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> tasks = [];

  //todo: add loading
  Future<void> getTasks() async {
    //todo: pagination
    List<TaskModel>? result = await RemoteServices.fetchTasks();
    if (result == null) {
      print("errorrrr"); //todo: show dialog
    }
    tasks.addAll(result ?? []);
    notifyListeners();
  }
}
