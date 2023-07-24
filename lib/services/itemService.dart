import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/Item.dart';

class ItemService {
  Future<ItemList> getAllItems() async {
    final response =
        await http.get(Uri.parse('http://localhost:3001/api/items'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseData = json.decode(response.body);

      print(responseData);
      return ItemList.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Items');
    }
  }

  Future<ItemList> getItemBySupplier(String supplierId) async {
    final response = await http
        .get(Uri.parse('http://localhost:3001/api/items/supplier/$supplierId'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseData = json.decode(response.body);

      print(responseData);
      return ItemList.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Items');
    }
  }
}
