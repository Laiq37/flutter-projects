import 'package:flutter/cupertino.dart';
import 'package:todo_app/api/todo_api.dart';
import 'package:todo_app/data/todo_model.dart';

class TodoProvider with ChangeNotifier {
  final List<Todo> todoList = [];

  Future<void> createTodo(Map<String, dynamic> data) async {
    try {
      final Map<String, dynamic>? todosData = await TodoApi().createTodo(data);
      if (todosData == null) return;
      todoList.add(Todo(
          id: todosData['id'],
          todoTitle: todosData['todo'],
          isDone: todosData['done'].toString()));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateTodo(int id, Map<String, dynamic> data) async {
    try {
      final isResponse = await TodoApi().updateTodo(data);
      if (!isResponse) return;

      todoList.firstWhere((e) => e.id == id).todoTitle = data['todo'];
      todoList.firstWhere((e) => e.id == id).isDone = data['done'];

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await TodoApi().deleteTodo({'id': id.toString()});
      todoList.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchTodos() async {
    try {
      final List<dynamic>? todosData = await TodoApi().fetchTodo();
      if (todosData == null) return;
      print(todosData.length);
      for (var e in todosData) {
        todoList.add(Todo(
            id: e['id'], todoTitle: e['todo'], isDone: e['done'].toString()));
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
