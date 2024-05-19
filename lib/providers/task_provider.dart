import 'package:bloc/models/task_model.dart';
import 'package:bloc/services/remote_services.dart';
import 'package:flutter/foundation.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> tasks = [];

  @override
  void onInit() {
    getTasks();
    super.onInit();
  }

  //todo: add loading
  Future<void> getTasks() async {
    //todo: pagination
    var res = await RemoteServices.fetchTasks();
    if (res == null) {
      print("errorrrr"); //todo: show dialog
    }
    tasks.addAll(res ?? []);
    notifyListeners();
  }
}
