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
      List<Color> colors = calculateColors(creationDate, date);
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


  static List<Color> calculateColors(DateTime createdAt, DateTime dueDate) {
    final totalDuration = dueDate.difference(createdAt).inMilliseconds.toDouble();
    final elapsedDuration = DateTime.now().difference(createdAt).inMilliseconds.toDouble();

    final progress = (elapsedDuration / totalDuration) * 100;

    if (progress < 20) {
      return [HabiticaColors.blue10, HabiticaColors.blue100];
    } else if (progress >= 20 && progress < 40) {
      return [HabiticaColors.green10, HabiticaColors.green100];
    } else if (progress >= 40 && progress < 60) {
      return [HabiticaColors.yellow10, HabiticaColors.yellow100];
    } else if (progress >= 60 && progress < 80) {
      return [HabiticaColors.orange10, HabiticaColors.orange100];
    } else if (progress >= 80 && progress < 100) {
      return [HabiticaColors.red10, HabiticaColors.red100];
    } else {
      return [HabiticaColors.maroon10, HabiticaColors.maroon100];
    }
  }

  static Todo createFromJsonResponse(Map<String, dynamic> input) {
    return Todo(
        input['_id'],
        text: input['text'],
        notes: input['notes'],
        completed: input['completed'],
        creationDate: input.containsKey('createdAt') ? DateTime.parse(input['createdAt']) : null,
        date: input.containsKey('date') ? DateTime.parse(input['date']) : null
    );
  }
}