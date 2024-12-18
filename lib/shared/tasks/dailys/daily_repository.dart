import 'daily.dart';
import 'package:habbitapp/shared/api/api_service.dart';

class DailyRepository {
  final List<Daily> _dailys = [];


  void append(Daily daily) {
    _dailys.add(daily);
  }


  List<Daily> getAll() {
    return List.unmodifiable(_dailys);
  }


  void downloadHabiticaDailys() async {
    try {
      Map<String, dynamic> response = await ApiService.getTasks(type: "dailys");

      if (response.containsKey("data")) {
        for (Map<String, dynamic> jsonDaily in response["data"]) {
          append(Daily.createFromJsonResponse(jsonDaily));
        }
      } else {
        print("Unexpected response");
      }

    } catch (e) {
      print(e);
    }
  }
}
