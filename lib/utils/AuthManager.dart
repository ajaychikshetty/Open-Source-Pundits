import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const _loggedInKey = 'loggedIn';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  static Future<void> setLoggedIn(
    bool loggedIn,

    String email,
  ) async {
    print("Setting $email");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, loggedIn);
    await prefs.setString("email", email);
    // rev_Homepage.UserName = Name;
    // rev_Homepage.SCid = uid;
  }

  static Future<Map<String, dynamic>?> getData() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    String? pid = prefs.getString("pid");
    return {"email": email, "pid": pid};
  }
}
