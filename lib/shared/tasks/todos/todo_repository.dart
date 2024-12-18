import 'package:habbitapp/shared/api/api_service.dart';

import 'todo.dart';

class TodosRepository {
  final List<Todo> _todos = [];


  void append(Todo daily) {
    _todos.add(daily);
  }


  List<Todo> getAll() {
    return List.unmodifiable(_todos);
  }


  void downloadHabiticaTodos() async {
    try {
      Map<String, dynamic> response = await ApiService.getTasks(type: "todos");

      if (response.containsKey("data")) {
        for (Map<String, dynamic> jsonDaily in response["data"]) {
          append(Todo.createFromJsonResponse(jsonDaily));
        }
      } else {
        print("Unexpected response");
      }

    } catch (e) {
      print(e);
    }
  }
}