import 'package:flutter/cupertino.dart';
import 'package:habbitapp/shared/api/api_service.dart';
import 'package:habbitapp/shared/tasks/habits/habit.dart';

class HabitRepository extends ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => List.unmodifiable(_habits);


  Future<void> append(Habit habit) async {
    try {
      Map<String, dynamic> response = await ApiService.addTask(habit.toJson(false));

      if (response.containsKey('error')) {
        throw response['error'];
      } else {
        if (response.containsKey('data') && response['data'].containsKey('id') && response['data']['id'] is String){
          habit.id = response['data']['id'];
        } else {
          print("Response does not contain 'id'?");
        }
        _habits.add(habit);
        notifyListeners();
      }

    } catch (e) {
      print(e);
    }
  }


  Future<void> downloadHabiticaHabits() async {
    try {
      Map<String, dynamic> response = await ApiService.getTasks(type: "habits");

      if (response.containsKey("data")) {
        for (Map<String, dynamic> jsonHabit in response["data"]) {
          _habits.add(Habit.createFromJsonResponse(jsonHabit));
        }
      } else {
        print("Unexpected response $response");
      }
    } catch (e) {
      print(e);
    }
  }
}