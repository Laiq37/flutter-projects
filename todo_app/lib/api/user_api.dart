import 'package:http/http.dart' as http;

class UserApi {
  static const String startingPoint =
      "https://kotlin-ktor-todo-app-server.herokuapp.com/v1";

  static String? token;

  Future<bool> createUser(String name, String email, String password) async {
    const String endPoint = "/users/create";
    try {
      print("$startingPoint$endPoint");
      http.Response response = await http.post(
          Uri.parse("$startingPoint$endPoint"),
          body: {"displayName": name, "email": email, "password": password});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    const String endPoint = "/users/login";
    try {
      print("$startingPoint$endPoint");
      http.Response response = await http.post(
          Uri.parse("$startingPoint$endPoint"),
          body: {"email": email, "password": password});

      if (response.statusCode == 200 || response.statusCode == 201) {
        token = response.body;
      }
      print(token);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
