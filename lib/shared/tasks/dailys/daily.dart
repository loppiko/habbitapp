import 'dart:ui';
import 'package:habbitapp/shared/consts/habitica_colors.dart';
import 'package:habbitapp/shared/tasks/sub_tasks/sub_tasks.dart';

class Daily {
  String _id;
  String _text, _notes, _frequency;
  int _everyX, _streak;
  double _priority;
  DateTime _startDate;
  bool _isDue, _completed;
  Map<String, bool> _repeat;
  Map<String, SubTask> _checklist;
  List<DateTime> _nextDue;
  Color _taskColor = HabiticaColors.red10;
  Color _circleColor = HabiticaColors.red100;


  Daily({String id = "", String text = "", String frequency = "", String notes = "", int everyX = 1, DateTime? startDate, int streak = 0, double priority = 1.0, bool isDue = false, bool completed = false, Map<String, bool>? repeat, Map<String, SubTask>? checklist, List<DateTime>? nextDue,
      })  : _id = id,
        _text = text,
        _frequency = frequency,
        _notes = notes,
        _everyX = everyX,
        _startDate = startDate ?? DateTime.now(),
        _priority = priority,
        _streak = streak,
        _isDue = isDue,
        _completed = completed,
        _repeat = repeat ?? <String, bool>{},
        _checklist = checklist ?? <String, SubTask> {},
        _nextDue = nextDue ?? [] {

      List<Color> colors = calculateColors(streak);
      _taskColor = colors[0];
      _circleColor = colors[1];
  }


  set id(String id) {
    _id = id;
  }


  String get id => _id;
  String get text => _text;
  String get frequency => _frequency;
  String get notes => _notes;
  int get everyX => _everyX;
  int get streak => _streak;
  double get priority => _priority;
  DateTime get startDate => _startDate;
  bool get isDue => _isDue;
  bool get completed => _completed;
  Map<String, bool> get repeat => Map.unmodifiable(_repeat);
  Map<String, SubTask> get checklist => Map.unmodifiable(_checklist);
  List<DateTime> get nextDue => List.unmodifiable(_nextDue);
  Color get taskColor => _taskColor;
  Color get circleColor => _circleColor;


  List<Color> calculateColors(int streak) {
    if (_completed) {
      return [HabiticaColors.gray300, HabiticaColors.gray400];
    } else if (streak >= 12) {
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
      id: input['_id'],
      text: input['text'],
      notes: input['notes'],
      frequency: input['frequency'],
      everyX: input['everyX'],
      startDate: DateTime.parse(input['startDate']),
      priority: input['priority'].toDouble(),
      streak: input['streak'],
      isDue: input['isDue'],
      completed: input['completed'],
      repeat: (input['repeat'] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, value as bool)),
      nextDue: (input['nextDue'] as List<dynamic>?)
          ?.map((date) => DateTime.parse(date as String))
          .toList()
    );
  }


  Map<String, dynamic> toJson(bool addId) {
    final Map<String, dynamic> data = {};

    if (_id.isNotEmpty && addId) data['_id'] = _id;
    data['type'] = "daily";
    data['text'] = _text;
    data['notes'] = _notes;
    data['frequency'] = _frequency;
    data['everyX'] = _everyX;
    data['completed'] = _completed;
    data['priority'] = _priority;
    data['streak'] = _streak;
    data['isDue'] = _isDue;
    data['creationDate'] = _startDate.toString();

    if (checklist.isNotEmpty) {
      final List<Map<String, dynamic>> subTaskList = [];
      _checklist.forEach((key, val) => subTaskList.add(val.toJson()));
      data['checklist'] = subTaskList;
    }
    if (_repeat.isNotEmpty) {
      final List<Map<String, dynamic>> repeatList = _repeat.entries
          .map((entry) => {entry.key: entry.value})
          .toList();
      data['repeat'] = repeatList;
    }

    return data;
  }


  int getTotalNumberOfChecklistSubTasks() {
    return _checklist.length;
  }


  int getDoneNumberOfChecklistSubTasks() {
    return _checklist.values.where((task) => task.completed).length;
  }


  void increaseStreak() {
    _completed = true;
    _streak++;
    List<Color> colors = calculateColors(streak);
    _taskColor = colors[0];
    _circleColor = colors[1];
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


  int nextDueInDays() {
    if (_nextDue.isEmpty) return -1;

    final now = DateTime.now();
    final nextDue = _nextDue.firstWhere(
            (date) => !date.isBefore(now)
    );
    final days = nextDue.difference(now).inDays;

    return days;
  }


  String nextDueInText() {
    if (_nextDue.isEmpty) return "No due dates available";

    final days = nextDueInDays();

    if (days == 0) {
    return "Today";
    } else if (days == 1) {
    return "Tomorrow";
    } else if (days == 2) {
    return "Next 2 days";
    } else if (days == 3) {
    return "Next 3 days";
    } else if (days <= 7) {
    return "Few days ahead";
    } else if (days <= 14) {
    return "Next 2 weeks";
    } else if (days <= 21) {
    return "Next 3 weeks";
    } else if (days <= 30) {
    return "Next month";
    } else if (days <= 90) {
    return "Next 3 months";
    } else if (days <= 180) {
    return "Next 6 months";
    } else {
    return "Far future";
    }
  }
}
