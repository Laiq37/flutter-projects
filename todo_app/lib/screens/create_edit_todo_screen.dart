import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/todo_provider.dart';

class CreateEditTodoScreen extends StatefulWidget {
  CreateEditTodoScreen({Key? key}) : super(key: key);

  final TextEditingController titleController = TextEditingController();

  @override
  State<CreateEditTodoScreen> createState() => _CreateEditTodoScreenState();
}

class _CreateEditTodoScreenState extends State<CreateEditTodoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> status = ["False", "True"];

  String value = "False";

  onSubmit(String title, String isDone) async {
    if (!_formKey.currentState!.validate()) return;
    final Map<String, dynamic> data = {
      "todo": title,
      "done": isDone,
    };
    await Provider.of<TodoProvider>(context, listen: false).createTodo(data);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: widget.titleController,
                decoration: const InputDecoration(
                  label: Text('title'),
                ),
                validator: (val) {
                  if (val == null) {
                    return "Title is required";
                  }
                  return null;
                },
              ),
              DropdownButton(
                items: status.map((String item) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(item.toString()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  print(newValue);
                  setState(() {
                    value = newValue!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onSubmit(widget.titleController.text, value),
        child: const Icon(Icons.done),
      ),
    );
  }
}
