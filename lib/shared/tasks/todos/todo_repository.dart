import 'package:flutter/foundation.dart';
import 'package:habbitapp/shared/api/api_service.dart';
import 'package:habbitapp/shared/tasks/todos/todo.dart';

class TodosRepository extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => List.unmodifiable(_todos);


  void append(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }


  Future<void> downloadHabiticaTodos() async {
    try {
      Map<String, dynamic> response = await ApiService.getTasks(type: "todos");

      if (response.containsKey("data")) {
        for (Map<String, dynamic> jsonTodo in response["data"]) {
          append(Todo.createFromJsonResponse(jsonTodo));
        }
      } else {
        print("Unexpected response $response");
      }
    } catch (e) {
      print(e);
    }
  }
}
