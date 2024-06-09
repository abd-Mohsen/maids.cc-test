import 'package:flutter/foundation.dart';

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
    //todo: put a timeout here
    toggleLoading(true);
    UserModel? result = await RemoteServices.fetchAuthUser();
    if (result == null) {
      print("errorrrr"); //todo: show dialog
      return;
    }
    currentUser = result;
    toggleLoading(false);
  }
}
