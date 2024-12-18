import 'dart:ui';
import 'package:habbitapp/shared/consts/habitica_colors.dart';

class Daily {
  final String _id;
  String _text, _frequency;
  int _everyX, _streak;
  DateTime _startDate;
  bool _isDue;
  Map<String, bool> _repeat;
  List<DateTime> _nextDue;
  Color _taskColor = HabiticaColors.red10;
  Color _circleColor = HabiticaColors.red100;


  Daily(
      this._id, {
        String text = "",
        String frequency = "",
        int everyX = 1,
        DateTime? startDate,
        int streak = 0,
        bool isDue = false,
        Map<String, bool>? repeat,
        List<DateTime>? nextDue,
      })  : _text = text,
        _frequency = frequency,
        _everyX = everyX,
        _startDate = startDate ?? DateTime.now(),
        _streak = streak,
        _isDue = isDue,
        _repeat = repeat ?? <String, bool>{},
        _nextDue = nextDue ?? [] {

      List<Color> colors = calculateColors(streak);
      _taskColor = colors[0];
      _circleColor = colors[1];
  }


  static List<Color> calculateColors(int streak) {
    if (streak >= 12) {
      return [HabiticaColors.blue10, HabiticaColors.blue100];
    } else if (streak >= 9 && streak < 12) {
      return [HabiticaColors.green10, HabiticaColors.green100];
    } else if (streak >= 6 && streak < 9) {
      return [HabiticaColors.yellow10, HabiticaColors.yellow100];
    } else if (streak >= 3 && streak < 6) {
      return [HabiticaColors.orange10, HabiticaColors.orange100];
    } else if (streak >= 1 && streak < 3) {
      return [HabiticaColors.red10, HabiticaColors.red100];
    } else {
      return [HabiticaColors.maroon10, HabiticaColors.maroon100];
    }
  }


  static Daily createFromJsonResponse(Map<String, dynamic> input) {
    return Daily(
      input['_id'],
      text: input['text'],
      frequency: input['frequency'],
      everyX: input['everyX'],
      startDate: DateTime.parse(input['startDate']),
      streak: input['streak'],
      isDue: input['isDue'],
      repeat: (input['repeat'] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, value as bool)),
      nextDue: (input['nextDue'] as List<dynamic>?)
          ?.map((date) => DateTime.parse(date as String))
          .toList()
    );
  }
}
