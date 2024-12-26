import 'package:flutter/cupertino.dart';
import 'package:habbitapp/shared/api/api_service.dart';
import 'package:habbitapp/shared/tasks/habits/habit.dart';

class HabitRepository extends ChangeNotifier {
  List<Habit> _todos = [];

  List<Habit> get todos => List.unmodifiable(_todos);


  void append(Habit todo) {
    _todos.add(todo);
    notifyListeners();
  }


  Future<void> downloadHabiticaTodos() async {
    try {
      Map<String, dynamic> response = await ApiService.getTasks(type: "todos");

      if (response.containsKey("data")) {
        for (Map<String, dynamic> jsonTodo in response["data"]) {
          append(Habit.createFromJsonResponse(jsonTodo));
        }
      } else {
        print("Unexpected response $response");
      }
    } catch (e) {
      print(e);
    }
  }
}