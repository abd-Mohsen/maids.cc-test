import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:maids.cc_test/constants.dart';

import '../models/task_model.dart';
import '../services/remote_services.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> tasks = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getTasks() async {
    //todo: pagination
    toggleLoading(true);
    try {
      List<TaskModel>? result = await RemoteServices.fetchTasks().timeout(kTimeOutDuration1);
      if (result == null) {
        print("error getting tasks, check your connection"); //todo: show dialog
      }
      tasks.addAll(result ?? []);
    } on TimeoutException {
      print("request timed out, check your connection"); //todo: show dialog
    } catch (e) {
      //
    }
    toggleLoading(false);
  }
}
