import 'package:poshuasengheng/constants/constants.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:poshuasengheng/models/category.dart';
import 'package:poshuasengheng/models/customer.dart';
import 'package:poshuasengheng/models/item.dart';
import 'package:poshuasengheng/models/orderdraft.dart';
import 'package:poshuasengheng/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductApi {
  const ProductApi();

  //get Product
  static Future<List<Product>> getProductCategory({required int categoryId}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.https(publicUrl, 'api/item', {'clientId': 'S0001', 'categoryId': categoryId.toString()});
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      final list = data['data'] as List;
      return list.map((e) => Product.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //get Category
  static Future<List<Category>> getCategorys() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.https(publicUrl, 'api/item-category', {'clientId': 'S0001'});
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      final list = data['data'] as List;
      return list.map((e) => Category.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }


  //add Order-darf
  static Future<OrderDraft> addOrderDarf({required List<Item> item, required Customer customer}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.https(publicUrl, 'api/order-darf');
    final response = await http.post(url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: convert.jsonEncode({
          "clientId": "M0013",
          "memberId": 1,
          "licensePage": customer.licensePage,
          "name": customer.name,
          "tel": customer.tel,
          "item": item
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return OrderDraft.fromJson(data['data']);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //add New Customer bt licensePage
  static Future<Customer> addCustomer({required String name, required String tel, required String licensePage}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.https(publicUrl, 'api/customer');
    final response = await http.post(url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: convert.jsonEncode({
          "name": name,
          "tel": tel,
          "licensePage": licensePage,
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return Customer.fromJson(data['data']);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //ค้นหาทะเบียรถลูกค้า
  static Future<List<Customer>> getLicensePage({required String licensePage}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.https(publicUrl, 'api/customer', {'licensePage': licensePage});
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      final list = data['data'] as List;
      return list.map((e) => Customer.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

}
