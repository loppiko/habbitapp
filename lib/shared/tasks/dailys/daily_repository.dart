import 'package:flutter/cupertino.dart';
import 'package:habbitapp/shared/user_data/UserProvider.dart';
import 'package:provider/provider.dart';

import 'daily.dart';
import 'package:habbitapp/shared/api/api_service.dart';

class DailyRepository extends ChangeNotifier {
  List<Daily> _dailys = [];


  Future<void> append(Daily habit) async {
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
        _dailys.add(habit);
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
        _dailys.removeWhere((daily) => daily.id == taskId);
        notifyListeners();
      }

    } catch (e) {
      print(e);
    }
  }

  // TODO: resolve option when daily was already scored
  Future<Map<String, double>> scoreDaily(BuildContext context, String taskId) async {
    try {
      Map<String, dynamic> response = await ApiService.scoreTask(taskId, isDown: false);

      if (response.containsKey('error')) {
        throw response['error'];
      } else {
        double moneyDiff = response['data']['gp'] - Provider.of<UserProvider>(context, listen: false).money;
        double expDiff = response['data']['exp'] - Provider.of<UserProvider>(context, listen: false).experience!.toDouble();

        Daily scoredDaily = findById(taskId)!;

        scoredDaily.increaseStreak();
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



  List<Daily> getAll() {
    return List.unmodifiable(_dailys);
  }


  Daily? findById(String id) {
    return _dailys.firstWhere((daily) => daily.id == id);
  }


  Future<void> downloadHabiticaDailys() async {
    try {
      Map<String, dynamic> response = await ApiService.getTasks(type: "dailys");
      _dailys = [];

      if (response.containsKey("data")) {
        for (Map<String, dynamic> jsonDaily in response["data"]) {
          _dailys.add(Daily.createFromJsonResponse(jsonDaily));
        }
      } else {
        print("Unexpected response $response.");
      }

    } catch (e) {
      print(e);
    }
  }
}
