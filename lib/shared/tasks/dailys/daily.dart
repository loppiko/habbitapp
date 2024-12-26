import 'dart:ui';
import 'package:habbitapp/shared/consts/habitica_colors.dart';
import 'package:habbitapp/shared/tasks/sub_tasks/sub_tasks.dart';

class Daily {
  final String _id;
  String _text, _notes, _frequency;
  int _everyX, _streak, _priority;
  DateTime _startDate;
  bool _isDue;
  Map<String, bool> _repeat;
  Map<String, SubTask> _checklist;
  List<DateTime> _nextDue;
  Color _taskColor = HabiticaColors.red10;
  Color _circleColor = HabiticaColors.red100;


  Daily(this._id, {String text = "", String frequency = "", String notes = "", int everyX = 1, DateTime? startDate, int streak = 0, int priority = 1, bool isDue = false, Map<String, bool>? repeat, Map<String, SubTask>? checklist, List<DateTime>? nextDue,
      })  : _text = text,
        _frequency = frequency,
        _notes = notes,
        _everyX = everyX,
        _startDate = startDate ?? DateTime.now(),
        _priority = priority,
        _streak = streak,
        _isDue = isDue,
        _repeat = repeat ?? <String, bool>{},
        _checklist = checklist ?? <String, SubTask> {},
        _nextDue = nextDue ?? [] {

      List<Color> colors = calculateColors(streak);
      _taskColor = colors[0];
      _circleColor = colors[1];
  }


  String get id => _id;
  String get text => _text;
  String get frequency => _frequency;
  String get notes => _notes;
  int get everyX => _everyX;
  int get streak => _streak;
  int get priority => _priority;
  DateTime get startDate => _startDate;
  bool get isDue => _isDue;
  Map<String, bool> get repeat => Map.unmodifiable(_repeat);
  Map<String, SubTask> get checklist => Map.unmodifiable(_checklist);
  List<DateTime> get nextDue => List.unmodifiable(_nextDue);
  Color get taskColor => _taskColor;
  Color get circleColor => _circleColor;


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
      notes: input['notes'],
      frequency: input['frequency'],
      everyX: input['everyX'],
      startDate: DateTime.parse(input['startDate']),
      priority: (input['priority'] * 2).round(),
      streak: input['streak'],
      isDue: input['isDue'],
      repeat: (input['repeat'] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, value as bool)),
      nextDue: (input['nextDue'] as List<dynamic>?)
          ?.map((date) => DateTime.parse(date as String))
          .toList()
    );
  }


  int getTotalNumberOfChecklistSubTasks() {
    return _checklist.length;
  }


  int getDoneNumberOfChecklistSubTasks() {
    return _checklist.values.where((task) => task.completed).length;
  }


  SubTask getSubTaskById(String id) {
    if (!_checklist.containsKey(id)) {
      throw ArgumentError('Key "$id" not found in the checklist.');
    }
    return _checklist[id]!;
  }


  bool subTaskInChecklist(String id) {
    return _checklist.containsKey(id);
  }
}
