import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/remote_services.dart';

class UserProvider extends ChangeNotifier {
  late UserModel currentUser;

  //todo: add loading
  Future<void> getAuthUser() async {
    //todo: pagination
    UserModel? result = await RemoteServices.fetchAuthUser();
    if (result == null) {
      print("errorrrr"); //todo: show dialog
      return;
    }
    currentUser = result;
    notifyListeners();
  }
}
