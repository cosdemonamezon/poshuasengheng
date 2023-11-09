import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:poshuasengheng/constants/constants.dart';
import 'package:poshuasengheng/extension/formattedMessage.dart';
import 'package:poshuasengheng/models/category.dart';
import 'package:poshuasengheng/models/customer.dart';
import 'package:poshuasengheng/models/product.dart';
import 'package:poshuasengheng/screen/product/cartProducts.dart';
import 'package:poshuasengheng/screen/product/services/productController.dart';
import 'package:poshuasengheng/widgets/LoadingDialog.dart';
import 'package:poshuasengheng/widgets/inputNumberDialog.dart';
import 'package:poshuasengheng/widgets/materialDialog.dart';
import 'package:provider/provider.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class ProductPage extends StatefulWidget {
  ProductPage({super.key, required this.customer});
  Customer customer;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _myNumber = TextEditingController();
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  List<Product> listProducts = [];
  List<Product> finalListProducts = [];
  List<Product> finalProducts = [];
  Product? selectProduct;
  //List<Category> categorys = [];
  Category? dropdownValue;
  @override
  void initState() {
    super.initState();
    //inspect(widget.customer);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getListCategory();
      //getListProducts();
    });

    _bindingPrinter().then((bool? isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });

      SunmiPrinter.printerVersion().then((String version) {
        setState(() {
          printerVersion = version;
        });
      });

      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });

      setState(() {
        printBinded = isBind!;
        //dropdownValue = list.first;
      });
    });
  }

  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  Future<void> getListProducts(Category category) async {
    LoadingDialog.open(context);
    try {
      await context.read<ProductController>().getListProductCategory(category);
      setState(() {
        listProducts = context.read<ProductController>().products;
        //finalListProducts = listProducts.where((element) => element.select == true).toList();
      });
      //inspect(finalListProducts);
      LoadingDialog.close(context);
    } on Exception catch (e) {
      LoadingDialog.close(context);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '${e.getMessage}',
          pressYes: () {
            Navigator.pop(context, true);
          },
        ),
      );
    }
  }

  Future<void> reGetListProducts(Category category) async {
    LoadingDialog.open(context);
    try {
      await context.read<ProductController>().getListProductCategory(category);
      setState(() {
        listProducts = context.read<ProductController>().products;
      });
      LoadingDialog.close(context);
    } on Exception catch (e) {
      LoadingDialog.close(context);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '${e.getMessage}',
          pressYes: () {
            Navigator.pop(context, true);
          },
        ),
      );
    }
  }

  Future<void> getListCategory() async {
    try {
      await context.read<ProductController>().getCategory();
      setState(() {
        dropdownValue = context.read<ProductController>().categorys[0];
      });
      getListProducts(dropdownValue!);
    } on Exception catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '${e.getMessage}',
          pressYes: () {
            Navigator.pop(context, true);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<ProductController>(builder: (context, controller, child) {
      final products = controller.products;
      final categorys = controller.categorys;
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('รายการสินค้า'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(Icons.arrow_back_ios)),
          actions: [
            Stack(
              children: [
                IconButton(
                    onPressed: () async {
                      if (finalListProducts.isNotEmpty) {
                        final cartProduct = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartProducts(
                                      finalListProducts: finalListProducts,
                                      customer: widget.customer,
                                    )));
                        setState(() {
                          if (cartProduct != null) {
                            finalListProducts = cartProduct;
                            //listProducts = finalListProducts;
                            //products = finalListProducts;
                          } else {
                            finalListProducts.clear();
                            for (var i = 0; i < listProducts.length; i++) {
                              if (listProducts[i].select == true) {
                                listProducts[i].select = false;
                                listProducts[i].qty = 1;
                                listProducts[i].qtyPack = 1;
                              }
                            }
                          }
                          //inspect(listProducts);
                        });
                      }
                    },
                    icon: Icon(
                      Icons.shopping_cart,
                      size: 30,
                    )),
                finalListProducts.isNotEmpty
                    ? Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 10,
                          child: Text(
                            '${finalListProducts.length}',
                            style: TextStyle(fontSize: 10),
                          ),
                        ))
                    : SizedBox()
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.01,
                ),
                // AppTextTowFormField(
                //   sufIcon: Icons.search,
                //   labelText: '',
                //   maxLines: 1,
                //   sufPress: () {
                //     print('object');
                //   },
                // ),
                SizedBox(
                  height: size.height * 0.10,
                  width: size.width * 0.65,
                  child: DropdownButtonFormField<Category>(
                    value: dropdownValue,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 30,
                    ),
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (Category? value) {
                      setState(() {
                        dropdownValue = value;
                      });
                      reGetListProducts(dropdownValue!);
                    },
                    items: categorys.map<DropdownMenuItem<Category>>((Category value) {
                      return DropdownMenuItem<Category>(
                        value: value,
                        child: Text(
                          value.name!,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Column(
                  children: [
                    GridView.count(
                        primary: false,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.all(20),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 1,
                        children: List.generate(
                          products.length,
                          (index) => GestureDetector(
                            onTap: () async {
                              final addQty = await showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                ),
                                backgroundColor: Colors.white,
                                context: context,
                                isScrollControlled: true,
                                useRootNavigator: true,

                                /// add this line to show bottomsheet over navbar
                                builder: (BuildContext context) {
                                  return Container(
                                    height: size.height * 0.90,
                                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 40),
                                        Padding(
                                          padding: EdgeInsets.all(20),
                                          child: SizedBox(
                                            height: size.height * 0.05,
                                            child: Center(
                                                child: TextField(
                                              controller: _myNumber,
                                              textAlign: TextAlign.center,
                                              showCursor: false,
                                              style: TextStyle(fontSize: 20),
                                              // Disable the default soft keybaord
                                              keyboardType: TextInputType.none,
                                            )),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        NumPad(
                                          buttonSize: 70,
                                          buttonColor: Colors.grey,
                                          iconColor: Colors.red,
                                          controller: _myNumber,
                                          delete: () {
                                            if (_myNumber.text != null) {
                                              if (_myNumber.text.length > 0) {
                                                _myNumber.text = _myNumber.text.substring(0, _myNumber.text.length - 1);
                                              }
                                            }
                                          },
                                          // do something with the input numbers
                                          onSubmit: () {
                                            debugPrint('Your code: ${_myNumber.text}');
                                            Navigator.pop(context, _myNumber.text);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              //print(addQty);
                              //inspect(products[index]);
                              if (addQty != null) {
                                setState(() {
                                  //finalListProducts.clear();
                                  try {
                                    List<String> check = [];
                                    for (var character in addQty.runes) {
                                      String singleCharacter = String.fromCharCode(character);
                                      print(singleCharacter);
                                      check.add(singleCharacter);
                                    }
                                    //inspect(check);
                                    final a = check.contains('x');
                                    if (a == true) {
                                      print('สุตรเดิม');
                                      List<String> substrings = addQty.split('/');
                                      for (var element in substrings) {
                                        List<String> substring2 = element.split('x');
                                        //products[index];
                                        final newProduct = Product.fromJson(products[index].toJson());
                                        inspect(newProduct);
                                        newProduct.qty = int.parse(substring2[0]);
                                        newProduct.qtyPack = int.parse(substring2[1]);
                                        finalListProducts.add(newProduct);
                                        _myNumber.clear();
                                      }
                                      inspect(finalListProducts);
                                    } else {
                                      print('สุตรใหม่');
                                      List<String> substrings = addQty.split('/');
                                      final newProduct = Product.fromJson(products[index].toJson());
                                      newProduct.qty = int.parse(substrings[0]);
                                      newProduct.qtyPack = 1;
                                      finalListProducts.add(newProduct);
                                      _myNumber.clear();
                                      //inspect(substrings);
                                      // for (var element in substrings) {
                                      //   List<String> substring2 = element.split(" ");
                                      //   final newProduct = Product.fromJson(products[index].toJson());
                                      //   newProduct.qty = int.parse(substring2[0]);
                                      //   newProduct.qtyPack = 1;
                                      //   finalListProducts.add(newProduct);
                                      //   _myNumber.clear();
                                      // }
                                      inspect(finalListProducts);
                                    }
                                    
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialogYes(
                                          title: 'แจ้งเตือน',
                                          description: 'รูปแบบข้อมูลไม่ถูกต้อง',
                                          pressYes: () {
                                            Navigator.pop(context, true);
                                          },
                                        );
                                      },
                                    );
                                  }
                                });
                              } else {
                                setState(() {
                                  _myNumber.clear();
                                });
                              }
                              // final productChange = await showDialog<Product?>(
                              //   context: context,
                              //   barrierDismissible: false,
                              //   builder: (BuildContext context) {
                              //     return InputNumberDialog(
                              //       product: products[index],
                              //     );
                              //   },
                              // );
                              // if (productChange != null) {
                              //   setState(() {
                              //     if (finalListProducts.isNotEmpty) {
                              //       for (var i = 0; i < finalListProducts.length; i++) {
                              //         final element = finalListProducts[i];
                              //         print('element ' + element.id.toString());
                              //         print('productChange ' + productChange.id.toString());
                              //         if (element.id == productChange.id) {
                              //           finalListProducts[i] = productChange;
                              //           return;
                              //         }
                              //       }

                              //       finalListProducts.add(productChange);
                              //       //finalListProducts.add(productChange);

                              //       print(finalListProducts.length);
                              //     } else {
                              //       finalListProducts.add(productChange);
                              //       // products[index] = productChange;
                              //       // inspect(listProducts);
                              //     }
                              //   });

                              //   //inspect(productChange);
                              // } else {
                              //   print('No Select Number');
                              // }
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              color: Color.fromARGB(255, 234, 247, 246),
                              child: Center(
                                  child: Column(
                                children: [
                                  products[index].image != null
                                      ? Image.network(
                                          products[index].image!,
                                          height: size.height * 0.25,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.asset(
                                          'assets/images/Screenshot.png',
                                          height: size.height * 0.25,
                                          fit: BoxFit.fill,
                                        ),
                                  Text(
                                    "${products[index].name}",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${products[index].details}",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "ราคาต่อถุง ${products[index].price} บาท",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "ราคาต่อกิโล ${products[index].price} บาท",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              )),
                            ),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Visibility(
          visible: true,
          child: BottomAppBar(
            clipBehavior: Clip.hardEdge,
            shape: CircularNotchedRectangle(),
            elevation: 25,
            child: InkWell(
              onTap: () async {
                if (finalListProducts.isNotEmpty) {
                  final cartProduct = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CartProducts(
                                finalListProducts: finalListProducts,
                                customer: widget.customer,
                              )));
                  setState(() {
                    if (cartProduct != null) {
                      finalListProducts = cartProduct;
                      //listProducts = finalListProducts;
                      //products = finalListProducts;
                    } else {
                      finalListProducts.clear();
                      for (var i = 0; i < listProducts.length; i++) {
                        if (listProducts[i].select == true) {
                          listProducts[i].select = false;
                          listProducts[i].qty = 1;
                          listProducts[i].qtyPack = 1;
                        }
                      }
                    }
                    inspect(listProducts);
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(color: kSecondaryColor, borderRadius: BorderRadius.all(Radius.circular(20))),
                height: size.height * 0.05,
                width: double.infinity,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'ยืนยันรายการ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // SizedBox(
                    //   width: 50,
                    //   height: 50,
                    //   child: Image.asset('assets/icons/live.png'),
                    // ),
                  ],
                )),
              ),
            ),
          ),
        ),
      );
    });
  }
}
