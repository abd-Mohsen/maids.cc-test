import 'dart:convert';
import 'package:bloc/constants.dart';
import 'package:bloc/models/task_model.dart';
import 'package:bloc/main.dart';
import 'package:http/http.dart' as http;

class RemoteServices {
  static var client = http.Client();
  static Map<String, String> headers = {"Accept": "application/json", "content-type": "application/json"};
  static String get token => await prefs.getString("token"); //todo: how?

  static Future<String?> login(String name, String password) async {
    var response = await http.post(Uri.parse("http://10.207.252.68:8067/api/Account/Login"),
        body: jsonEncode(
          {
            "username": name,
            "password": password,
            "branchId": 1,
          },
        ),
        headers: {"Accept": "application/json", "content-type": "application/json"});
    print(response.body);
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return res['data']['token'];
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
