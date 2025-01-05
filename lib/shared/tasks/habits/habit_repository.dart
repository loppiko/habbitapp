import 'package:flutter/cupertino.dart';
import 'package:habbitapp/shared/api/api_service.dart';
import 'package:habbitapp/shared/tasks/habits/habit.dart';
import 'package:habbitapp/shared/user_data/UserProvider.dart';
import 'package:provider/provider.dart';

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


  Future<void> remove(String taskId) async {
    try {
      Map<String, dynamic> response = await ApiService.deleteTask(taskId);

      if (response.containsKey('error')) {
        throw response['error'];
      } else {
        _habits.removeWhere((daily) => daily.id == taskId);
        notifyListeners();
      }

    } catch (e) {
      print(e);
    }
  }


  Future<Map<String, double>> scoreHabit(BuildContext context, String taskId, bool isDown) async {
    try {
      Map<String, dynamic> response = await ApiService.scoreTask(taskId, isDown: isDown);

      if (response.containsKey('error')) {
        throw response['error'];
      } else {
        double moneyDiff = response['data']['gp'] - Provider.of<UserProvider>(context, listen: false).money;
        double expDiff = response['data']['exp'] - Provider.of<UserProvider>(context, listen: false).experience!.toDouble();

        if (isDown) {
          findById(taskId)!.increaseCounterDown();
        } else {
          findById(taskId)!.increaseCounterUp();
        }

        notifyListeners();

        return {
          'moneyDiff': moneyDiff,
          'expDiff': expDiff,
        };
      }

    } catch (e) {
      print(e);
      return {
        'moneyDiff': 0.0,
        'expDiff': 0.0,
      };
    }
  }


  Habit? findById(String id) {
    return _habits.firstWhere((daily) => daily.id == id);
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