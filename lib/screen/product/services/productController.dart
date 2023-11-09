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
    final _products = await ProductApi.getProductCategory(categoryId: category.id!);
    
    if (_products.isNotEmpty) {    
      products = _products; 
      //products = _products.where((element) => element.name == 'กระเทียม').toList();
      //products = _products.where((element) => element.itemCategory!.name == category.name).toList();
    }    
    notifyListeners();
  }

  getCategory() async{
    categorys.clear();
    categorys = await ProductApi.getCategorys();
    notifyListeners();
  }
}