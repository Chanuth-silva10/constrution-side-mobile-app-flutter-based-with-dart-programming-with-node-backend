import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/Order.dart';

class OrderService {
  Future<OrderList> getAllOrders() async {
    final response =
        await http.get(Uri.parse('https://aaaaa-9u7y.onrender.com/api/orders'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      return OrderList.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load orders');
    }
  }

  Future<int> createOrder(Map<String, dynamic> data) async {
    print(data);
    final response = await http.post(
      Uri.parse('https://aaaaa-9u7y.onrender.com/api/orders'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return jsonDecode(response.body)['orderReferenceNo'];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
