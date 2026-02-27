import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic>? user;

  bool get isAuthenticated => user != null;
  String get userName => user?['name'] ?? 'Doctor';
  String get userRole => user?['role'] ?? 'health_officer';

  Future<bool> login(String email, String password) async {
    // TODO: Replace with your real API call e.g:
    // final response = await http.post(Uri.parse('$baseUrl/auth/login'),
    //   body: {'email': email, 'password': password});
    // if (response.statusCode == 200) { user = jsonDecode(response.body); }

    await Future.delayed(const Duration(seconds: 1));

    // Demo: accepts any credentials
    user = {
      'name': 'Dr. Saloh',
      'email': email,
      'role': 'health_officer',
      'facility': {'name': 'Afyalink Medical Center'},
    };
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    user = null;
    notifyListeners();
  }
}