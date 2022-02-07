import 'package:http/http.dart' as http;
import 'user_api.dart';
import 'dart:convert';

class TodoApi {
  static const String startingPoint =
      "https://kotlin-ktor-todo-app-server.herokuapp.com/v1";

  static const String endPoint = "/todos";

  final Map<String, String> headers = {
    'Authorization': 'Bearer ${UserApi.token}',
    'Cookie': "MY_SESSION=userId%3D%2523i26",
  };

  final Uri url = Uri.parse('$startingPoint$endPoint');

  Future<Map<String, dynamic>?> createTodo(Map<String, dynamic> data) async {
    try {
      http.Response response =
          await http.post(url, headers: headers, body: data);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future updateTodo(Map<String, dynamic> data) async {
    try {
      http.Response response =
          await http.post(url, headers: headers, body: data);
      print(response.statusCode);
      if (response.statusCode == 200) return true;
    } catch (e) {
      print(e);
    }
  }

  Future deleteTodo(Map<String, dynamic> data) async {
    try {
      http.Response response =
          await http.delete(url, headers: headers, body: data);
    } catch (e) {
      print(e);
    }
  }

  Future<List<dynamic>?> fetchTodo() async {
    try {
      http.Response response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }
}
