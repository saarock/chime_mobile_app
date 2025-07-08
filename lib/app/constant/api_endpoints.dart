class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // For Android Emulator
  static const String serverAddress = "http://10.0.2.2:8000";
  // For iOS Simulator
  //static const String serverAddress = "http://localhost:3000";

  // For iPhone (uncomment if needed)
  static const String baseUrl = "$serverAddress/api/v1/users";

  static const String verifyUser = "$serverAddress/api/v1/users/verify-user";

  // Auth url
  static const String login = "/login-with-google";
  static const updateUserImportantDetails = "/add-user-important-details";
}
