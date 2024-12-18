class Daily {
  final String _id;
  String _text;
  String _frequency;
  int _everyX;
  DateTime _startDate;
  int _streak;
  bool _isDue;
  Map<String, bool> _repeat;
  List<DateTime> _nextDue;


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
  }
}
