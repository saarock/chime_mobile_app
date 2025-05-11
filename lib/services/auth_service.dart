import "dart:convert";

import "package:http/http.dart" as http;

class AuthService {
  static const String url = "http://localhost:8000/api/v1/users/";

  Future<void> loginWithGoogle({
    required String credentials,
    required String clientId,
  }) async {
    try {
      print(
        "**********************************************************************2",
      );

      final response = await http.post(
        Uri.parse("http://localhost:8000/api/v1/users/login-with-google"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"credentials": credentials, "clientId": clientId}),
      );

      if (response.statusCode == 200) {
        print("Auth success: ${response.body}");
      } else {
        print("Auth failed");
      }
    } catch (error) {}
  }
}
