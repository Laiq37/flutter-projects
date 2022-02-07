import 'package:http/http.dart' as http;

class UserApi {
  static const String startingPoint =
      "https://kotlin-ktor-todo-app-server.herokuapp.com/v1";

  static String? token;

  Future<bool> createUser(String name, String email, String password) async {
    const String endPoint = "/users/create";
    print('increate user api');
    try {
      print("$startingPoint$endPoint");
      http.Response response = await http.post(
          Uri.parse("$startingPoint$endPoint"),
          body: {"displayName": name, "email": email, "password": password});
      print(response.body.toString());
      print(response.statusCode);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    const String endPoint = "/users/login";
    print('increate user api');
    try {
      print("$startingPoint$endPoint");
      http.Response response = await http.post(
          Uri.parse("$startingPoint$endPoint"),
          body: {"email": email, "password": password});
      print(response.statusCode);

      token = response.body;
      print(token);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
