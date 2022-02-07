import 'package:http/http.dart' as http;
import 'user_api.dart';

class TodoApi {
  static const String startingPoint =
      "https://kotlin-ktor-todo-app-server.herokuapp.com/v1";

  static const String endPoint = "/todos";
  Future createTodo(Map<String, dynamic> data) async {
    print('in Api create todo method');
    try {
      print(UserApi.token);
      http.Response response =
          await http.post(Uri.parse('$startingPoint$endPoint'),
              headers: {
                'Authorization': 'Bearer ${UserApi.token}',
              },
              body: data);
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }

  Future updateTodo(Map<String, dynamic> data) async {
    print('in Api create todo method');
    try {
      print(UserApi.token);
      http.Response response = await http.post(
          Uri.parse('$startingPoint$endPoint'),
          headers: {'Authorization': 'Bearer ${UserApi.token}'},
          body: data);
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future deleteTodo(Map<String, dynamic> data) async {
    print('in Api create todo method');
    try {
      print(UserApi.token);
      http.Response response = await http.post(
          Uri.parse('$startingPoint$endPoint'),
          headers: {'Authorization': 'Bearer ${UserApi.token}'},
          body: data);
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future fetchTodo() async {
    print('in Api create todo method');
    try {
      print(UserApi.token);
      http.Response response = await http.get(
        Uri.parse('$startingPoint$endPoint'),
        headers: {'Authorization': 'Bearer ${UserApi.token}'},
      );
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }
}
