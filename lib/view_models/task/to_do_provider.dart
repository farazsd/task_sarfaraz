import 'package:flutter/material.dart';
import '../../helpers/database_helper.dart';
import '../../models/task/to_do_model.dart';

class TodoProvider with ChangeNotifier {
  Future<List<Todo>> fetchTodos() async {
    final dataList = await DBHelper().getTodos();
    // notifyListeners();
    return dataList.map((e) => Todo.fromMap(e)).toList();
  }

  Future<List<Todo>> get todos async {
    return fetchTodos();
  }

  Future<void> addTodo(Todo todo) async {
    await DBHelper().insertTodo(todo.toMap());
    notifyListeners();
  }

  Future<void> updateTodo(Todo todo) async {
    if (todo.id != null) {
      await DBHelper().updateTodo(todo.id!, todo.toMap());
      notifyListeners();
    }
  }

  Future<void> deleteTodo(int id) async {
    await DBHelper().deleteTodo(id);
    notifyListeners();
  }
}
