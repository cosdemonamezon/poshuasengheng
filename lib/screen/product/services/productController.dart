import 'package:flutter/material.dart';
import 'package:poshuasengheng/models/category.dart';
import 'package:poshuasengheng/models/itemAll.dart';
import 'package:poshuasengheng/models/priceUint.dart';
import 'package:poshuasengheng/models/product.dart';
import 'package:poshuasengheng/models/product2.dart';
import 'package:poshuasengheng/screen/product/services/productApi.dart';

class ProductController extends ChangeNotifier {
  ProductController({this.api = const ProductApi()});

  ProductApi api;

  List<Product2> products = [];
  List<Category> categorys = [];
  List<ItemAll> productsNew = [];
  // PriceUint? dataPrice;

  getListProductCategory(Category category) async {
    products.clear();
    final _products = await ProductApi.getProductCategory(categoryId: category.id!);

    if (_products.isNotEmpty) {
      products = _products;
      //products = _products.where((element) => element.name == 'กระเทียม').toList();
      //products = _products.where((element) => element.itemCategory!.name == category.name).toList();
    }
    notifyListeners();
  }

  getListProductCategoryAll({Category? categoryId}) async {
    productsNew.clear();
    final _products = await ProductApi.getProductCategoryall(categoryId: categoryId);

    if (_products.isNotEmpty) {
      productsNew = _products;
      //products = _products.where((element) => element.name == 'กระเทียม').toList();
      //products = _products.where((element) => element.itemCategory!.name == category.name).toList();
    }
    notifyListeners();
  }

  // getPriceUint(int itemId, int value) async {
  //   dataPrice = await ProductApi.getPriceUint(itemId: itemId, value: value);
  //   notifyListeners();
  // }

  getCategory() async {
    categorys.clear();
    categorys = await ProductApi.getCategorys();
    notifyListeners();
  }
}
