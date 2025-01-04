import 'package:flutter/cupertino.dart';
import 'package:habbitapp/shared/api/api_service.dart';
import 'package:habbitapp/shared/tasks/todos/todo.dart';
import 'package:habbitapp/shared/user_data/UserProvider.dart';
import 'package:provider/provider.dart';

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


  Future<Map<String, double>> scoreTodo(BuildContext context, String taskId) async {
    try {
      Map<String, dynamic> response = await ApiService.scoreTask(taskId, isDown: false);

      if (response.containsKey('error')) {
        throw response['error'];
      } else {
        _todos.removeWhere((daily) => daily.id == taskId);

        double moneyDiff = response['data']['gp'] - Provider.of<UserProvider>(context, listen: false).money;
        double expDiff = response['data']['exp'] - Provider.of<UserProvider>(context, listen: false).experience!.toDouble();

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
