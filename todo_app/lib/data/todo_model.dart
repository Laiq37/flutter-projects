import 'package:flutter/foundation.dart';

class Todo {
  String? id;
  final String todoTitle;
  final String isDone;

  Todo({id, required this.todoTitle, required this.isDone});
}
