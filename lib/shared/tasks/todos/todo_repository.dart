import 'package:flutter/foundation.dart';
import 'package:habbitapp/shared/api/api_service.dart';
import 'package:habbitapp/shared/tasks/todos/todo.dart';

class TodosRepository extends ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => List.unmodifiable(_todos);


  Future<void> append(Todo todo) async {
    try {
      Map<String, dynamic> response = await ApiService.addTask(todo.toJson(false));

      if (response.containsKey('error')) {
        throw response['error'];
      } else {
        if (response.containsKey('data') && response['data'].containsKey('id') && response['data']['id'] is String){
          todo.id = response['data']['id'];
        } else {
          print("Response does not contain 'id'?");
        }
        _todos.add(todo);
        notifyListeners();
      }

    } catch (e) {
      print(e);
    }
  }


  Future<void> remove(String taskId) async {
    try {
      Map<String, dynamic> response = await ApiService.deleteTask(taskId);

      if (response.containsKey('error')) {
        throw response['error'];
      } else {
        _todos.removeWhere((daily) => daily.id == taskId);
        notifyListeners();
      }

    } catch (e) {
      print(e);
    }
  }


  Future<void> downloadHabiticaTodos() async {
    try {
      Map<String, dynamic> response = await ApiService.getTasks(type: "todos");

      if (response.containsKey("data")) {
        for (Map<String, dynamic> jsonTodo in response["data"]) {
          _todos.add(Todo.createFromJsonResponse(jsonTodo));
        }

        notifyListeners();
      } else {
        print("Unexpected response $response");
      }
    } catch (e) {
      print(e);
    }
  }
}
