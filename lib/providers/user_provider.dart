import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../main.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';

class UserProvider extends ChangeNotifier {
  UserModel? currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getAuthUser() async {
    try {
      toggleLoading(true);
      UserModel? result = await RemoteServices.fetchAuthUser().timeout(kTimeOutDuration1);
      if (result == null) {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) => kCheckConnectionDialog,
        );
      }
      currentUser = result;
    } on TimeoutException {
      // showDialog(
      //   context: navigatorKey.currentContext!,
      //   builder: (context) => kTimeoutDialog,
      // );
    } catch (e) {
      //
    } finally {
      toggleLoading(false);
    }
  }
}
