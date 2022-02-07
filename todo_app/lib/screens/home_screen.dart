import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/todo_model.dart';
import 'package:todo_app/provider/todo_provider.dart';
import 'package:todo_app/screens/create_edit_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future? _orderFuture;
  Future _obtainOrderFuture() {
    return Provider.of<TodoProvider>(context, listen: false).fetchTodos();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orderFuture = _obtainOrderFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      // body: Center(
      //   child: TextButton(
      //       child: const Text('fetchTodos'),
      //       onPressed: () async {
      //         await Provider.of<TodoProvider>(context, listen: false).fetchTodos();
      //       }),
      // ),
      body: FutureBuilder(
        future: _orderFuture,
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : Provider.of<TodoProvider>(context).todoList != []
                ? ListView(
                    children: [
                      ...Provider.of<TodoProvider>(context).todoList.map((e) =>
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateEditTodoScreen(
                                          id: e.id,
                                          title: e.todoTitle,
                                          status: e.isDone,
                                          isEditing: true,
                                        ))),
                            onLongPress: () => showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Delete'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text('Confirm Delete.'),
                                          Text(
                                              'Would you like to delete this Tast?'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Yes'),
                                        onPressed: () async {
                                          print(e.id);
                                          Provider.of<TodoProvider>(context,
                                                  listen: false)
                                              .deleteTodo(e.id!);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                }),
                            child: ListTile(
                              title: Text(e.todoTitle),
                              trailing: Text(e.isDone),
                            ),
                          ))
                    ],
                  )
                : const Center(
                    child: Text('no todos created yet'),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => CreateEditTodoScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
