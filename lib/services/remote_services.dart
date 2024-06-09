import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maids.cc_test/models/user_model.dart';

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
          "expiresInMins": 1,
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
    if (await handleRefreshToken(response.statusCode)) {
      return fetchTasks();
    }
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
    if (await handleRefreshToken(response.statusCode)) {
      return fetchAuthUser();
    }
    return null;
  }

  static Future<bool> handleRefreshToken(int statusCode) async {
    if (statusCode != 401) return false;
    var response = await http.post(
      Uri.parse("$kHostIP/auth/refresh"),
      body: jsonEncode(
        {
          "refreshToken": refreshToken,
          "expiresInMins": 1,
        },
      ),
      headers: headers,
    );
    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      prefs.setString("token", result["token"]);
      prefs.setString("refresh_token", result["refreshToken"]);
      print("refreshed token");
      return true;
    }
    return false;
  }

  static Future<TaskModel?> addTask(String todo, bool completed, int userId) async {
    var response = await http.post(
      Uri.parse("$kHostIP/todos/add"),
      body: jsonEncode(
        {
          "todo": todo,
          "completed": completed,
          "userId": userId,
        },
      ),
      headers: headers,
    );
    print(response.body);
    var res = jsonDecode(response.body);
    if (response.statusCode == 201) {
      print("success");
      return TaskModel.fromJson(res);
    }
    return null;
  }

  static Future<TaskModel?> updateTask(int id, bool completed) async {
    var response = await http.patch(
      Uri.parse("$kHostIP/todos/$id"),
      body: jsonEncode(
        {
          "completed": completed,
        },
      ),
      headers: headers,
    );
    print(response.body);
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("success");
      return TaskModel.fromJson(res);
    }
    return null;
  }

  static Future<bool> deleteTask(int id) async {
    var response = await http.delete(
      Uri.parse("$kHostIP/todos/$id"),
      headers: headers,
    );
    if (response.statusCode == 200) {
      print("success");
      return true;
    }
    return false;
  }
}
