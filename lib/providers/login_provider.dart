import 'dart:async';

import 'package:flutter/material.dart';

import '../constants.dart';
import '../main.dart';
import '../models/login_model.dart';
import '../services/remote_services.dart';

class LoginProvider extends ChangeNotifier {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> login() async {
    buttonPressed = true;
    bool valid = loginFormKey.currentState!.validate();
    if (!valid) return;
    try {
      setLoading(true);
      LoginModel? response = await RemoteServices.login(userName.text, password.text).timeout(kTimeOutDuration1);
      if (response == null) {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) => kLoginFailedDialog,
        );
      } else {
        prefs.setString("token", response.token);
        prefs.setString("refresh_token", response.refreshToken);
        navigatorKey.currentState!.pushNamedAndRemoveUntil("/home", (route) => false);
      }
    } on TimeoutException {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => kTimeoutDialog,
      );
    } catch (e) {
      print(e.toString());
    }
    setLoading(false);
  }
}
