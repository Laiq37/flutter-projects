import 'package:flutter/cupertino.dart';
import 'package:todo_app/api/todo_api.dart';
import 'package:todo_app/data/todo_model.dart';

class TodoProvider with ChangeNotifier {
  final List<Todo> todoList = [];

  Future createTodo(Map<String, dynamic> data) async {
    print(data);
    try {
      await TodoApi().createTodo(data);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future updateTodo(Map<String, dynamic> data) async {
    print(data);
    try {
      await TodoApi().updateTodo(data);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future deleteTodo(Map<String, dynamic> data) async {
    try {
      await TodoApi().deleteTodo(data);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future fetchTodos() async {
    try {
      await TodoApi().fetchTodo();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
