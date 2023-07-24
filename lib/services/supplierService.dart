import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/Supplier.dart';

class SupplierService {
  Future<SupplierList> getAllSuppliers() async {
    final response =
        await http.get(Uri.parse('http://localhost:3001/api/supplier'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseData = json.decode(response.body);

      print(responseData);
      return SupplierList.fromJson(responseData);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load suppliers');
    }
  }
}
