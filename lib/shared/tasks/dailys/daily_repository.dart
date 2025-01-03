import 'package:flutter/cupertino.dart';

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


  List<Daily> getAll() {
    return List.unmodifiable(_dailys);
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
