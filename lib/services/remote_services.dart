import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../main.dart';
import '../models/login_model.dart';
import '../models/task_model.dart';

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
      Map tasks = jsonDecode(response.body)["todos"];
      return taskModelFromJson(jsonEncode(tasks));
    }
    print("failed ${response.statusCode}");
    return null;
  }
}
