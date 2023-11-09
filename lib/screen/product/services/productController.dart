import 'package:flutter/material.dart';
import 'package:poshuasengheng/models/category.dart';
import 'package:poshuasengheng/models/product.dart';
import 'package:poshuasengheng/screen/product/services/productApi.dart';

class ProductController extends ChangeNotifier {
  ProductController({this.api = const ProductApi()});

  ProductApi api;

  List<Product> products = [];
  List<Category> categorys = [];

  getListProductCategory(Category category) async{
    products.clear();
    final _products = await ProductApi.getProductCategory();
    products = _products.where((element) => element.name == category.name).toList();
    notifyListeners();
  }

  getCategory() async{
    categorys.clear();
    categorys = await ProductApi.getCategorys();
    notifyListeners();
  }
}