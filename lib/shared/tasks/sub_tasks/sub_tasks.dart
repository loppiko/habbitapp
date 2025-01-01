class SubTask {
  String _id;
  String _text;
  bool _completed;


  SubTask(this._id, {String text = "", bool completed = false})
      : _text = text,
    _completed = completed;


  String get id => _id;
  String get text => _text;
  bool get completed => _completed;


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = _id;
    data['text'] = _text;
    data['completed'] = _completed;

    return data;
  }
}