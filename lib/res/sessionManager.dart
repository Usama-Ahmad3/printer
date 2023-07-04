class SessionController {
  static final SessionController _sessionController =
      SessionController._internal();
  String? userId;
  factory SessionController() {
    return _sessionController;
  }
  SessionController._internal() {}
}
