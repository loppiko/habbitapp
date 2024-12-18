import 'package:habbitapp/shared/api/api_service.dart';

import 'todo.dart';

class TodosRepository {
  final List<Todo> _dailys = [];


  void append(Todo daily) {
    _dailys.add(daily);
  }


  List<Todo> getAll() {
    return List.unmodifiable(_dailys);
  }


  void downloadHabiticaTodos() async {
    try {
      Map<String, dynamic> response = await ApiService.getTasks(type: "dailys");

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