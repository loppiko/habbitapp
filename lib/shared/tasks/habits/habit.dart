import 'dart:ui';

import 'package:habbitapp/shared/consts/habitica_colors.dart';
import 'package:habbitapp/shared/tasks/sub_tasks/sub_tasks.dart';

class Habit {
  final String _id;
  String _text, _frequency, _notes;
  int _counterUp, _counterDown, _priority;
  DateTime? _creationDate;
  bool _up, _down;
  Map<String, SubTask> _checklist;
  Color _taskColor = HabiticaColors.red10;
  Color _circleColor = HabiticaColors.red100;


  Habit(this._id, { String text = "", String notes = "", String frequency = "", int counterUp = 0, int counterDown = 0, int priority = 1, bool up = true, bool down = true,
    Map<String, SubTask>? checklist, DateTime? creationDate})
      : _text = text,
        _notes = notes,
        _frequency = frequency,
        _counterUp = counterUp,
        _counterDown = counterDown,
        _priority = priority,
        _up = up,
        _down = down,
        _checklist = checklist ?? <String, SubTask> {},
        _creationDate = creationDate ?? DateTime.now() {
      List<Color> colors = calculateColors(_counterUp, _counterDown, _up, _down);
      _taskColor = colors[0];
      _circleColor = colors[1];
  }


  String get id => _id;
  String get text => _text;
  String get frequency => _frequency;
  String get notes => _notes;
  int get counterUp => _counterUp;
  int get counterDown => _counterDown;
  int get priority => _priority;
  DateTime? get creationDate => _creationDate;
  bool get up => _up;
  bool get down => _down;
  Map<String, SubTask> get checklist => _checklist;
  Color get taskColor => _taskColor;
  Color get circleColor => _circleColor;


  List<Color> calculateColors(int counterUp, int counterDown, bool up, bool down) {
    int progress;

    if (up && down) {
      progress = counterUp - counterDown;
    } else if (up) {
      progress = counterUp - 6;
    } else {
      progress = counterDown - 6;
    }

    if (progress >= 6) {
      return [HabiticaColors.blue10, HabiticaColors.blue100];
    } else if (progress >= 3 && progress < 6) {
      return [HabiticaColors.green10, HabiticaColors.green100];
    } else if (progress >= 0 && progress < 3) {
      return [HabiticaColors.yellow10, HabiticaColors.yellow100];
    } else if (progress >= -3 && progress < 0) {
      return [HabiticaColors.orange10, HabiticaColors.orange100];
    } else if (progress >= -6 && progress < -3) {
      return [HabiticaColors.red10, HabiticaColors.red100];
    } else {
      return [HabiticaColors.maroon10, HabiticaColors.maroon100];
    }
  }


  static Habit createFromJsonResponse(Map<String, dynamic> input) {
    return Habit(
        input['_id'],
        text: input['text'],
        frequency: input['frequency'],
        notes: input['notes'],
        counterUp: input['counterUp'],
        counterDown: input['counterDown'],
        priority: (input['priority'] * 2).round(),
        up: input['up'],
        down: input['down'],
        creationDate: input.containsKey('createdAt') ? DateTime.parse(input['createdAt']) : null,
    );
  }


}