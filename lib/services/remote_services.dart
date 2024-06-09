import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maids.cc_test/models/user_model.dart';

import '../constants.dart';
import '../main.dart';
import '../models/login_model.dart';
import '../models/task_model.dart';

typedef CallerFunctionType<T> = R Function<T, R>(T);

class RemoteServices {
  static var client = http.Client();
  //static String hostIP = "https://dummyjson.com";
  static Map<String, String> headers = {
    "Accept": "application/json",
    "content-type": "application/json",
  };
  static String get token => prefs.getString("token") ?? "";
  static String get refreshToken => prefs.getString("refresh_token") ?? "";
  //todo: handle refresh_token

  static Future<LoginModel?> login(String name, String password) async {
    var response = await http.post(
      Uri.parse("$kHostIP/auth/login"),
      body: jsonEncode(
        {
          "username": name,
          "password": password,
        },
      ),
      headers: headers,
    );
    print(response.body);
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return loginModelFromJson(response.body);
    }
    print(res);
    print(res['Message']);
    return null;
  }

  //todo: do a unit test, expect a list of tasks
  static Future<List<TaskModel>?> fetchTasks({int limit = 10, int skip = 10}) async {
    var response = await http.get(Uri.parse("$kHostIP/todos?limit=$limit&skip=$skip"), headers: headers);
    if (response.statusCode == 200) {
      List tasks = jsonDecode(response.body)["todos"];
      return taskModelFromJson(jsonEncode(tasks));
    }
    print("failed ${response.statusCode}");
    handleRefreshToken(response.statusCode, fetchTasks, [limit, skip]);
    return null;
  }

  static Future<UserModel?> fetchAuthUser() async {
    var response = await http.get(Uri.parse("$kHostIP/auth/me"), headers: {
      ...headers,
      "Authorization": "Bearer $token",
    });
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    print(response.body);
    print("failed ${response.statusCode}");
    handleRefreshToken(response.statusCode, fetchAuthUser, []);
    return null;
  }

  static Future<void> handleRefreshToken(int statusCode, Function caller, List params) async {
    // todo: refreshing works fine, but not sure if the caller get called, test further
    if (statusCode != 401) return;
    var response = await http.post(
      Uri.parse("$kHostIP/auth/refresh"),
      body: jsonEncode(
        {
          "refreshToken": refreshToken,
          "expiresInMins": 60,
        },
      ),
      headers: headers,
    );
    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      prefs.setString("token", result["token"]);
      prefs.setString("refresh_token", result["refreshToken"]);
    }
    Function.apply(caller, params);
    // save new tokens
  }

  //todo: make a method that handles refresh token, takes status code, refresh tokens and recalls the caller function
}
