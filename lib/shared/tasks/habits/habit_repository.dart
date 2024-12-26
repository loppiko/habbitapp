import 'package:flutter/cupertino.dart';
import 'package:habbitapp/shared/api/api_service.dart';
import 'package:habbitapp/shared/tasks/habits/habit.dart';

class HabitRepository extends ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => List.unmodifiable(_habits);


  void append(Habit todo) {
    _habits.add(todo);
    notifyListeners();
  }


  Future<void> downloadHabiticaHabits() async {
    try {
      Map<String, dynamic> response = await ApiService.getTasks(type: "habits");

      if (response.containsKey("data")) {
        for (Map<String, dynamic> jsonHabit in response["data"]) {
          append(Habit.createFromJsonResponse(jsonHabit));
        }
      } else {
        print("Unexpected response $response");
      }
    } catch (e) {
      print(e);
    }
  }
}