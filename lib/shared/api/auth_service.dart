class AuthService {
  static final AuthService _instance = AuthService._internal();
  String? _token;
  String? _userId;

  AuthService._internal();

  factory AuthService() => _instance;

  void setToken(String token) {
    _token = token;
  }

  void setUserId(String userId) {
    _userId = userId;
  }

  String? getToken() {
    return _token;
  }

  String? getUserId() {
    return _userId;
  }
}
