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
  Color _leftTaskColor = HabiticaColors.red10;
  Color _leftCircleColor = HabiticaColors.red100;
  Color _rightTaskColor = HabiticaColors.red10;
  Color _rightCircleColor = HabiticaColors.red100;



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
      _leftTaskColor = colors[0];
      _leftCircleColor = colors[1];
      _rightTaskColor = colors[2];
      _rightCircleColor = colors[3];
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
  Color get leftTaskColor => _leftTaskColor;
  Color get leftCircleColor => _leftCircleColor;
  Color get rightTaskColor => _rightTaskColor;
  Color get rightCircleColor => _rightCircleColor;



  List<Color> calculateColors(int counterUp, int counterDown, bool up, bool down) {
    int progress;
    List<Color> activeColors = [];

    if (up && down) {
      progress = counterUp - counterDown;
    } else if (up) {
      progress = counterUp - 6;
    } else {
      progress = counterDown - 6;
    }

    if (progress >= 6) {
      activeColors = [HabiticaColors.blue10, HabiticaColors.blue100];
    } else if (progress >= 3 && progress < 6) {
      activeColors = [HabiticaColors.green10, HabiticaColors.green100];
    } else if (progress >= 0 && progress < 3) {
      activeColors = [HabiticaColors.yellow10, HabiticaColors.yellow100];
    } else if (progress >= -3 && progress < 0) {
      activeColors = [HabiticaColors.orange10, HabiticaColors.orange100];
    } else if (progress >= -6 && progress < -3) {
      activeColors = [HabiticaColors.red10, HabiticaColors.red100];
    } else {
      activeColors = [HabiticaColors.maroon10, HabiticaColors.maroon100];
    }

    if (up && down) {
      return [activeColors[0], activeColors[1], activeColors[0], activeColors[1]];
    } else if (up) {
      return [activeColors[0], activeColors[1], HabiticaColors.gray300, HabiticaColors.gray400];
    } else {
      return [HabiticaColors.gray300, HabiticaColors.gray400, activeColors[0], activeColors[1]];
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