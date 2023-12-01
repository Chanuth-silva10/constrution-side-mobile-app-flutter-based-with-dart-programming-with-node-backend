import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/Delivery.dart';

class DeliveryService {
  Future<DeliveryList> getAllDeliveries() async {
    final response = await http.get(Uri.parse(
        'https://build-craft-backend-site.onrender.com/api/deliveries'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      return DeliveryList.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load deliveries');
    }
  }

  Future<int> createDelivery(Map<String, dynamic> data) async {
    print(data);
    final response = await http.post(
      Uri.parse('https://build-craft-backend-site.onrender.com/api/deliveries'),
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
