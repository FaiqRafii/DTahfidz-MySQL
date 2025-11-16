import 'dart:convert';
import 'package:http/http.dart' as http;

class UserViewModel {
  Future<bool> changePassword(String id_user, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:4000/users/change-password"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_user': id_user, 'newPassword': newPassword}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Error change password: ${e}");
    }
  }
}
