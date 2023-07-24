import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginService {
  Future authenticate(Map<String, dynamic> data) async {
    print(data);
    final response = await http.post(
      Uri.parse('http://localhost:3001/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var token = jsonDecode(response.body)['token'];
      return {'status': 200, 'token': token};
    } else if (response.statusCode == 401 || response.statusCode == 404) {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return {'status': 401};
    } else {
      return {'status': 500};
    }
  }
}
