import 'dart:ui';
import 'package:habbitapp/shared/consts/habitica_colors.dart';

class Todo {
  final String _id;
  String _text;
  String _notes;
  bool _completed;
  DateTime? _creationDate;
  DateTime? _date;
  Color _taskColor = HabiticaColors.red10;
  Color _circleColor = HabiticaColors.red100;

  Todo(
      this._id, {
        String text = "",
        String notes = "",
        bool completed = false,
        DateTime? creationDate,
        DateTime? date,
      })  : _text = text,
        _notes = notes,
        _completed = completed,
        _creationDate = creationDate ?? DateTime.now(),
        _date = date {
    if (creationDate != null && date != null) {
      List<Color> colors = HabiticaColors.calculateColors(creationDate, date);
      _taskColor = colors[0];
      _circleColor = colors[1];
    }
  }

  String get id => _id;
  String get text => _text;
  String get notes => _notes;
  bool get completed => _completed;
  Color get taskColor => _taskColor;
  Color get circleColor => _circleColor;
  DateTime? get creationDate => _creationDate;
  DateTime? get date => _date;
}