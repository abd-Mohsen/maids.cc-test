import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maids.cc_test/constants.dart';
import 'package:maids.cc_test/main.dart';
import 'package:maids.cc_test/services/local_services.dart';
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

  void addTask(TaskModel task) {
    tasks.add(task);
    notifyListeners();
  }

  void updateTask(TaskModel task, bool val) {
    task.completed = val;
    notifyListeners();
  }

  void deleteTask(TaskModel task) {
    tasks.remove(task);
    notifyListeners();
  }

  int page = 0, limit = 10;
  bool hasMore = true;

  Future<void> refreshTasks() async {
    page = 0;
    hasMore = true;
    tasks.clear();
    getTasks();
  }

  Future<void> getTasks() async {
    if (page == 0) toggleLoading(true);
    try {
      List<TaskModel>? newTasks = await RemoteServices.fetchTasks(
        limit: limit,
        skip: limit * page,
      ).timeout(kTimeOutDuration1);
      if (newTasks == null) {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) => kCheckConnectionDialog,
        );
      } else {
        if (newTasks.length < 10) hasMore = false;
        tasks.addAll(newTasks);
        LocalServices.storeNewTasks(newTasks);
      }
    } on TimeoutException {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => kTimeoutDialog,
      );
    } catch (e) {
      //
    } finally {
      toggleLoading(false);
    }
    page++;
  }
}
