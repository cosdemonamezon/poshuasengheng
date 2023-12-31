// import 'dart:convert';
// import 'dart:developer';
// import 'dart:ui' as ui;

// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:poshuasengheng/constants/constants.dart';
// import 'package:poshuasengheng/models/customer.dart';
// import 'package:poshuasengheng/models/groupproduct.dart';
// import 'package:poshuasengheng/models/item.dart';
// import 'package:poshuasengheng/models/priceUint.dart';
// import 'package:poshuasengheng/models/product.dart';
// import 'package:poshuasengheng/models/product2.dart';
// import 'package:poshuasengheng/screen/printer/printerService.dart';
// import 'package:poshuasengheng/screen/product/services/productApi.dart';
// import 'package:poshuasengheng/screen/product/services/productController.dart';
// import 'package:poshuasengheng/widgets/LoadingDialog.dart';
// import 'package:poshuasengheng/widgets/materialDialog.dart';
// import 'package:provider/provider.dart';
// import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

// class CartProducts extends StatefulWidget {
//   CartProducts({super.key, required this.finalListProducts, required this.customer});
//   List<Product> finalListProducts;
//   Customer customer;

//   @override
//   State<CartProducts> createState() => _CartProductsState();
// }

// class _CartProductsState extends State<CartProducts> {
//   int qty = 1;
//   int qtyPack = 1;
//   bool printBinded = false;
//   int paperSize = 0;
//   String serialNumber = "";
//   String printerVersion = "";
//   List<Product> _finalListProducts = [];
//   List<Product> _newFinalListProducts = [];
//   Image? img;
//   GlobalKey globalKey = GlobalKey();
//   Uint8List? pngBytes;
//   Uint8List? pngBytesPag;
//   String? bs64;
//   bool show = false;
//   List<Item> items = [];
//   Map<String?, List<Product>>? newGroup;
//   //List<GroupProduct>? groupProduct;
//   List<MapEntry<String, List<Product>>> groupProduct = [];
//   bool enable = false;
//   List<PriceUint> qtyPrice = [];
//   List<Product2> product2 = [];

//   @override
//   void initState() {
//     super.initState();
//     priceUnit();
//     inspect(widget.finalListProducts);
//     _bindingPrinter().then((bool? isBind) async {
//       SunmiPrinter.paperSize().then((int size) {
//         setState(() {
//           paperSize = size;
//         });
//       });

//       SunmiPrinter.printerVersion().then((String version) {
//         setState(() {
//           printerVersion = version;
//         });
//       });

//       SunmiPrinter.serialNumber().then((String serial) {
//         setState(() {
//           serialNumber = serial;
//         });
//       });

//       setState(() {
//         printBinded = isBind!;
//         _finalListProducts = widget.finalListProducts;
//         if (_finalListProducts.isNotEmpty) {
//           groupProduct = groupBy(_finalListProducts, (e) => '${e.name}').entries.toList();
//           // inspect(groupProduct);
//           // print(groupProduct[0].key);
//           // print(groupProduct[0].value[0].qty);
//           // print(groupProduct[1].key);
//           // print(groupProduct[1].value[1].qty);
//         }
//         inspect(groupProduct);
//       });
//     });
//   }

//   Future<void> priceUnit() async {
//     final qty2 = await ProductApi.getListPriceUint(
//       item: widget.finalListProducts,
//     );
//     inspect(qty);
//     setState(() {
//       product2 = qty2;
//     });
//     // final qty = await context
//     //     .read<ProductController>()
//     //     .getPriceUint(widget.finalListProducts[i].id, widget.finalListProducts[i].qtyPack ?? 0);
//     // inspect(qty);
//     // setState(() {
//     //   qtyPrice.add(qty);
//     //   // inspect(qtyPrice);
//     // });
//   }

//   Future<bool?> _bindingPrinter() async {
//     final bool? result = await SunmiPrinter.bindingPrinter();
//     return result;
//   }

//   Future<Uint8List?> _capturePngPag() async {
//     try {
//       print('inside');
//       RenderRepaintBoundary boundary1 = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//       ui.Image image = await boundary1.toImage(pixelRatio: 1.75);
//       ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//       pngBytesPag = byteData!.buffer.asUint8List();
//       bs64 = base64Encode(pngBytesPag!);
//       // ui.Codec codec = await ui.instantiateImageCodec(pngBytes!);
//       // ui.FrameInfo frame;
//       // frame = await codec.getNextFrame();
//       //await PrinterService().print(widget.customer, _finalListProducts, pngBytes!);
//       print(pngBytesPag);
//       print(bs64);
//       setState(() {});
//       return pngBytesPag;
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<Uint8List?> _capturePng() async {
//     try {
//       print('inside');
//       RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//       ui.Image image = await boundary.toImage(pixelRatio: 1.75);
//       ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//       pngBytes = byteData!.buffer.asUint8List();
//       bs64 = base64Encode(pngBytes!);
//       // ui.Codec codec = await ui.instantiateImageCodec(pngBytes!);
//       // ui.FrameInfo frame;
//       // frame = await codec.getNextFrame();
//       //await PrinterService().print(widget.customer, _finalListProducts, pngBytes!);
//       print(pngBytes);
//       print(bs64);
//       setState(() {});
//       return pngBytes;
//     } catch (e) {
//       print(e);
//     }
//   }

//   // Create a NumberFormat instance for Thai Baht currency formatting
//   NumberFormat currencyFormat = NumberFormat.currency(
//     locale: 'th_TH', // Thai locale
//     symbol: '', // Thai Baht symbol
//   );

//   double sum(List<Product> product) => product.fold(
//       0,
//       (
//         previous,
//         o,
//       ) =>
//           previous + ((o.qty! * o.qtyPack!) * o.price!));

//   double newtotal(Product orders) => double.parse(((orders.qty! * orders.qtyPack!) * orders.price!).toString());
//   double sumQty(List<Product> productQty) =>
//       productQty.fold(0, (previousValue, element) => previousValue + double.parse(element.qty.toString()));
//   double sumQtyPack(List<Product> productQtyPack) =>
//       productQtyPack.fold(0, (previousValue, element) => previousValue + double.parse(element.qtyPack.toString()));
//   double sumPrice(List<Product> productPrice) =>
//       productPrice.fold(0, (previousValue, element) => previousValue + newtotal(element));

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('รายการสินค้าในตะกร้า'),
//         leading: IconButton(
//             onPressed: () {
//               if (widget.finalListProducts.isNotEmpty) {
//                 Navigator.pop(context, _finalListProducts);
//               } else {
//                 Navigator.pop(context, null);
//               }
//             },
//             icon: Icon(Icons.arrow_back_ios)),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: size.height * 0.02,
//               ),
//               Center(
//                 child: Text('ทะเบียนรถ: ${widget.customer.licensePage}',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     )),
//               ),
//               Center(
//                 child: Text('ชื่อลูกค้า: ${widget.customer.name}',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     )),
//               ),
//               Center(
//                 child: Text('เบอร์โทรศัพท์: ${widget.customer.tel}',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     )),
//               ),
//               SizedBox(
//                 height: size.height * 0.02,
//               ),
//               _finalListProducts.isNotEmpty
//                   ? Column(
//                       children: List.generate(
//                           _finalListProducts.length,
//                           (index) => Card(
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                         flex: 3,
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
//                                           child: Column(
//                                             children: [
//                                               Text('${widget.finalListProducts[index].name}'),
//                                               _finalListProducts[index].image != null
//                                                   ? Image.network(
//                                                       _finalListProducts[index].image!,
//                                                       fit: BoxFit.fill,
//                                                       height: size.height * 0.12,
//                                                     )
//                                                   : Image.asset(
//                                                       'assets/images/noimage.jpg',
//                                                       fit: BoxFit.fill,
//                                                       height: size.height * 0.12,
//                                                     ),
//                                             ],
//                                           ),
//                                         )),
//                                     Expanded(
//                                         flex: 4,
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: size.width * 0.01, vertical: size.height * 0.01),
//                                           child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 'จำนวน',
//                                                 style: TextStyle(fontSize: 14),
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   InkWell(
//                                                     onTap: () {
//                                                       setState(() {
//                                                         if (_finalListProducts[index].qty! > 1) {
//                                                           _finalListProducts[index].qty =
//                                                               _finalListProducts[index].qty! - 1;
//                                                         } else {}
//                                                       });
//                                                     },
//                                                     child: Container(
//                                                       decoration:
//                                                           BoxDecoration(border: Border.all(color: kDisableColor)),
//                                                       child: Icon(Icons.remove),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                           border: Border.all(color: kDisableColor),
//                                                           color: Colors.white),
//                                                       width: size.width * 0.11,
//                                                       child: Center(
//                                                           child: Text(
//                                                         '${_finalListProducts[index].qty}',
//                                                         style: TextStyle(fontSize: 15),
//                                                       )),
//                                                     ),
//                                                   ),
//                                                   InkWell(
//                                                     onTap: () {
//                                                       setState(() {
//                                                         _finalListProducts[index].qty =
//                                                             _finalListProducts[index].qty! + 1;
//                                                       });
//                                                     },
//                                                     child: Container(
//                                                       decoration:
//                                                           BoxDecoration(border: Border.all(color: kDisableColor)),
//                                                       child: Icon(Icons.add),
//                                                     ),
//                                                   ),
//                                                   // Padding(
//                                                   //   padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
//                                                   //   child: Text('${_finalListProducts[index].unit}'),
//                                                   // )
//                                                 ],
//                                               ),
//                                               Padding(
//                                                 padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
//                                                 child: Text('ราคา ${_finalListProducts[index].price} บาท'),
//                                               ),
//                                               Divider(),
//                                               Text(
//                                                 'ถุง',
//                                                 style: TextStyle(fontSize: 14),
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   InkWell(
//                                                     onTap: () {
//                                                       setState(() {
//                                                         if (_finalListProducts[index].qtyPack! > 1) {
//                                                           _finalListProducts[index].qtyPack =
//                                                               _finalListProducts[index].qtyPack! - 1;
//                                                         } else {}
//                                                       });
//                                                     },
//                                                     child: Container(
//                                                       decoration:
//                                                           BoxDecoration(border: Border.all(color: kDisableColor)),
//                                                       child: Icon(Icons.remove),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                           border: Border.all(color: kDisableColor),
//                                                           color: Colors.white),
//                                                       width: size.width * 0.11,
//                                                       child: Center(
//                                                           child: Text(
//                                                         '${_finalListProducts[index].qtyPack}',
//                                                         style: TextStyle(fontSize: 15),
//                                                       )),
//                                                     ),
//                                                   ),
//                                                   InkWell(
//                                                     onTap: () {
//                                                       setState(() {
//                                                         _finalListProducts[index].qtyPack =
//                                                             _finalListProducts[index].qtyPack! + 1;
//                                                       });
//                                                     },
//                                                     child: Container(
//                                                       decoration:
//                                                           BoxDecoration(border: Border.all(color: kDisableColor)),
//                                                       child: Icon(Icons.add),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Padding(
//                                                 padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
//                                                 child: Text(
//                                                     'ราคา ${_finalListProducts[index].price} บาท'), //${qtyPrice[index].price_per_unit}
//                                               ),
//                                               Divider(),
//                                             ],
//                                           ),
//                                         )),
//                                     Expanded(
//                                         flex: 2,
//                                         child: IconButton(
//                                             onPressed: () {
//                                               setState(() {
//                                                 _finalListProducts.removeAt(index);
//                                                 if (_finalListProducts.isNotEmpty) {
//                                                   groupProduct =
//                                                       groupBy(_finalListProducts, (e) => '${e.name}').entries.toList();
//                                                 } else {
//                                                   groupProduct.clear();
//                                                 }
//                                               });
//                                               //inspect(widget.finalListProducts);
//                                             },
//                                             icon: Icon(
//                                               Icons.delete,
//                                               color: Colors.red,
//                                               size: 32,
//                                             )))
//                                   ],
//                                 ),
//                               )),
//                     )
//                   : SizedBox(),
//               SizedBox(
//                 height: size.height * 0.13,
//               ),

//               SizedBox(
//                 height: size.height * 0.13,
//               ),

//               groupProduct.isNotEmpty
//                   ? Column(children: [
//                       Center(
//                         child: Text('ตัวอย่างการพิมพ์'),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
//                         child: Card(
//                           margin: EdgeInsets.zero,
//                           elevation: 0,
//                           color: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             side: BorderSide(
//                               color: Color.fromARGB(255, 238, 231, 231),
//                               width: 2.0,
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: RepaintBoundary(
//                               key: globalKey,
//                               child: Container(
//                                 width: size.width * 0.60,
//                                 color: Colors.white,
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                             flex: 7,
//                                             child: Text(
//                                               'สินค้า',
//                                               style: TextStyle(fontSize: 16),
//                                             )),
//                                         Expanded(
//                                             flex: 3,
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.end,
//                                               children: [
//                                                 Text(
//                                                   'ราคา',
//                                                   style: TextStyle(fontSize: 16),
//                                                 )
//                                               ],
//                                             ))
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           'หน่วย xกิโล/หน่วย xราคา/กิโล',
//                                           style: TextStyle(fontSize: 13),
//                                         )
//                                       ],
//                                     ),
//                                     Column(
//                                       children: List.generate(
//                                           groupProduct.length,
//                                           (index) => Column(
//                                                 children: [
//                                                   Row(
//                                                     mainAxisAlignment: MainAxisAlignment.start,
//                                                     children: [
//                                                       Text(
//                                                           '${groupProduct[index].key}  ${sumQty(groupProduct[index].value)} x ${int.parse(sumQtyPack(groupProduct[index].value).round().toString())}'),
//                                                     ],
//                                                   ),
//                                                   Column(
//                                                     children: List.generate(
//                                                       groupProduct[index].value.length,
//                                                       (index2) => Row(
//                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                         children: [
//                                                           Expanded(
//                                                             flex: 6,
//                                                             child: Text(
//                                                                 '(${groupProduct[index].value[index2].qty} x ${groupProduct[index].value[index2].qtyPack}) x ${groupProduct[index].value[index2].price}'), //${groupProduct[index].value[index2].price}${qtyPrice[index2].price_per_unit}
//                                                           ),
//                                                           Expanded(
//                                                               flex: 4,
//                                                               child: Row(
//                                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                                 children: [
//                                                                   enable == false
//                                                                       ? Text('')
//                                                                       : Text(
//                                                                           '${currencyFormat.format(newtotal(groupProduct[index].value[index2]))}'),
//                                                                 ],
//                                                               )),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Row(
//                                                     mainAxisAlignment: MainAxisAlignment.end,
//                                                     children: [
//                                                       enable == false
//                                                           ? Text('')
//                                                           : Text(
//                                                               'รวม ${currencyFormat.format(sumPrice(groupProduct[index].value))}'),
//                                                       //Text('${sumPrice(groupProduct[index].value)}'),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               )),
//                                     ),
//                                     Divider(
//                                       thickness: 2,
//                                       height: 2,
//                                       color: Colors.black,
//                                     ),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                             flex: 5,
//                                             child: Text(
//                                               'รวามรายการ',
//                                               style: TextStyle(fontSize: 16),
//                                             )),
//                                         Expanded(
//                                             flex: 5,
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.end,
//                                               children: [
//                                                 Text(
//                                                   '1',
//                                                   style: TextStyle(fontSize: 16),
//                                                 )
//                                               ],
//                                             ))
//                                       ],
//                                     ),
//                                     Divider(
//                                       thickness: 2,
//                                       height: 2,
//                                       color: Colors.black,
//                                     ),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                             flex: 5,
//                                             child: Text(
//                                               'รวมเป็น',
//                                               style: TextStyle(fontSize: 16),
//                                             )),
//                                         Expanded(
//                                             flex: 5,
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.end,
//                                               children: [
//                                                 enable == false
//                                                     ? Text('0')
//                                                     : Text(
//                                                         '${currencyFormat.format(sum(_finalListProducts))}',
//                                                         style: TextStyle(fontSize: 16),
//                                                       )
//                                               ],
//                                             ))
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                             flex: 5,
//                                             child: Text(
//                                               'ยอดค้าง',
//                                               style: TextStyle(fontSize: 16),
//                                             )),
//                                         Expanded(
//                                             flex: 5,
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.end,
//                                               children: [
//                                                 Text(
//                                                   '0',
//                                                   style: TextStyle(fontSize: 16),
//                                                 )
//                                               ],
//                                             ))
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                             flex: 5,
//                                             child: Text(
//                                               'ยอดชำระ',
//                                               style: TextStyle(fontSize: 16),
//                                             )),
//                                         Expanded(
//                                             flex: 5,
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.end,
//                                               children: [
//                                                 Text(
//                                                   '0',
//                                                   style: TextStyle(fontSize: 16),
//                                                 )
//                                               ],
//                                             ))
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                             flex: 5,
//                                             child: Text(
//                                               'รวมค้าง',
//                                               style: TextStyle(fontSize: 16),
//                                             )),
//                                         Expanded(
//                                             flex: 5,
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.end,
//                                               children: [
//                                                 enable == false
//                                                     ? Text('0')
//                                                     : Text(
//                                                         '${currencyFormat.format(sum(_finalListProducts))}',
//                                                         style: TextStyle(fontSize: 16),
//                                                       )
//                                               ],
//                                             ))
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                             flex: 5,
//                                             child: Text(
//                                               'ทอน',
//                                               style: TextStyle(fontSize: 16),
//                                             )),
//                                         Expanded(
//                                             flex: 5,
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.end,
//                                               children: [
//                                                 Text(
//                                                   '0',
//                                                   style: TextStyle(fontSize: 16),
//                                                 )
//                                               ],
//                                             ))
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ])
//                   : SizedBox(),

//               ///อันนี้คือรายการสั่งปริ๊น ที่ฟิกขนาดให้พอดีไว้เพื่อแคปรูป ตอนไปปริ๊น
//               // _finalListProducts.isNotEmpty
//               //     ? Column(children: [
//               //         Center(
//               //           child: Text('ตัวอย่างการพิมพ์'),
//               //         ),
//               //         Padding(
//               //           padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
//               //           child: Card(
//               //             margin: EdgeInsets.zero,
//               //             elevation: 0,
//               //             color: Colors.white,
//               //             shape: RoundedRectangleBorder(
//               //               side: BorderSide(
//               //                 color: Color.fromARGB(255, 238, 231, 231),
//               //                 width: 2.0,
//               //               ),
//               //               borderRadius: BorderRadius.circular(8),
//               //             ),
//               //             child: Padding(
//               //               padding: EdgeInsets.all(8.0),
//               //               child: RepaintBoundary(
//               //                 key: globalKey,
//               //                 child: Container(
//               //                   width: size.width * 0.60,
//               //                   color: Colors.white,
//               //                   child: Column(
//               //                     children: [
//               //                       Row(
//               //                         children: [
//               //                           Expanded(
//               //                               flex: 7,
//               //                               child: Text(
//               //                                 'สินค้า',
//               //                                 style: TextStyle(fontSize: 16),
//               //                               )),
//               //                           Expanded(
//               //                               flex: 3,
//               //                               child: Row(
//               //                                 mainAxisAlignment: MainAxisAlignment.end,
//               //                                 children: [
//               //                                   Text(
//               //                                     'ราคา',
//               //                                     style: TextStyle(fontSize: 16),
//               //                                   )
//               //                                 ],
//               //                               ))
//               //                         ],
//               //                       ),
//               //                       Row(
//               //                         children: [
//               //                           Text(
//               //                             'หน่วย xกิโล/หน่วย xราคา/กิโล',
//               //                             style: TextStyle(fontSize: 13),
//               //                           )
//               //                         ],
//               //                       ),
//               //                       Column(
//               //                         children: List.generate(
//               //                             _finalListProducts.length,
//               //                             (index) => Column(
//               //                                   children: [
//               //                                     Row(
//               //                                       children: [
//               //                                         Expanded(
//               //                                             flex: 7,
//               //                                             child: Text(
//               //                                               '${_finalListProducts[index].name}',
//               //                                               style: TextStyle(fontSize: 16),
//               //                                             )),
//               //                                         Expanded(
//               //                                             flex: 3,
//               //                                             child: Row(
//               //                                               mainAxisAlignment: MainAxisAlignment.end,
//               //                                               children: [
//               //                                                 Text(
//               //                                                   '${newtotal(_finalListProducts[index])}',
//               //                                                   style: TextStyle(fontSize: 16),
//               //                                                 )
//               //                                               ],
//               //                                             ))
//               //                                       ],
//               //                                     ),
//               //                                     Row(
//               //                                       children: [
//               //                                         Text(
//               //                                           '${_finalListProducts[index].qty} x${_finalListProducts[index].qtyPack} x${_finalListProducts[index].price}',
//               //                                           style: TextStyle(fontSize: 13),
//               //                                         )
//               //                                       ],
//               //                                     ),
//               //                                   ],
//               //                                 )),
//               //                       ),
//               //                       Divider(
//               //                         thickness: 2,
//               //                         height: 2,
//               //                         color: Colors.black,
//               //                       ),
//               //                       Row(
//               //                         children: [
//               //                           Expanded(
//               //                               flex: 7,
//               //                               child: Text(
//               //                                 'รวามรายการ',
//               //                                 style: TextStyle(fontSize: 16),
//               //                               )),
//               //                           Expanded(
//               //                               flex: 3,
//               //                               child: Row(
//               //                                 mainAxisAlignment: MainAxisAlignment.end,
//               //                                 children: [
//               //                                   Text(
//               //                                     '1',
//               //                                     style: TextStyle(fontSize: 16),
//               //                                   )
//               //                                 ],
//               //                               ))
//               //                         ],
//               //                       ),
//               //                       Divider(
//               //                         thickness: 2,
//               //                         height: 2,
//               //                         color: Colors.black,
//               //                       ),
//               //                       Row(
//               //                         children: [
//               //                           Expanded(
//               //                               flex: 7,
//               //                               child: Text(
//               //                                 'รวมเป็น',
//               //                                 style: TextStyle(fontSize: 16),
//               //                               )),
//               //                           Expanded(
//               //                               flex: 3,
//               //                               child: Row(
//               //                                 mainAxisAlignment: MainAxisAlignment.end,
//               //                                 children: [
//               //                                   Text(
//               //                                     '${sum(_finalListProducts)}',
//               //                                     style: TextStyle(fontSize: 16),
//               //                                   )
//               //                                 ],
//               //                               ))
//               //                         ],
//               //                       ),
//               //                       Row(
//               //                         children: [
//               //                           Expanded(
//               //                               flex: 7,
//               //                               child: Text(
//               //                                 'ยอดค้าง',
//               //                                 style: TextStyle(fontSize: 16),
//               //                               )),
//               //                           Expanded(
//               //                               flex: 3,
//               //                               child: Row(
//               //                                 mainAxisAlignment: MainAxisAlignment.end,
//               //                                 children: [
//               //                                   Text(
//               //                                     '0',
//               //                                     style: TextStyle(fontSize: 16),
//               //                                   )
//               //                                 ],
//               //                               ))
//               //                         ],
//               //                       ),
//               //                       Row(
//               //                         children: [
//               //                           Expanded(
//               //                               flex: 7,
//               //                               child: Text(
//               //                                 'ยอดชำระ',
//               //                                 style: TextStyle(fontSize: 16),
//               //                               )),
//               //                           Expanded(
//               //                               flex: 3,
//               //                               child: Row(
//               //                                 mainAxisAlignment: MainAxisAlignment.end,
//               //                                 children: [
//               //                                   Text(
//               //                                     '0',
//               //                                     style: TextStyle(fontSize: 16),
//               //                                   )
//               //                                 ],
//               //                               ))
//               //                         ],
//               //                       ),
//               //                       Row(
//               //                         children: [
//               //                           Expanded(
//               //                               flex: 7,
//               //                               child: Text(
//               //                                 'รวมค้าง',
//               //                                 style: TextStyle(fontSize: 16),
//               //                               )),
//               //                           Expanded(
//               //                               flex: 3,
//               //                               child: Row(
//               //                                 mainAxisAlignment: MainAxisAlignment.end,
//               //                                 children: [
//               //                                   Text(
//               //                                     '${sum(_finalListProducts)}',
//               //                                     style: TextStyle(fontSize: 16),
//               //                                   )
//               //                                 ],
//               //                               ))
//               //                         ],
//               //                       ),
//               //                       Row(
//               //                         children: [
//               //                           Expanded(
//               //                               flex: 7,
//               //                               child: Text(
//               //                                 'ทอน',
//               //                                 style: TextStyle(fontSize: 16),
//               //                               )),
//               //                           Expanded(
//               //                               flex: 3,
//               //                               child: Row(
//               //                                 mainAxisAlignment: MainAxisAlignment.end,
//               //                                 children: [
//               //                                   Text(
//               //                                     '0',
//               //                                     style: TextStyle(fontSize: 16),
//               //                                   )
//               //                                 ],
//               //                               ))
//               //                         ],
//               //                       ),
//               //                     ],
//               //                   ),
//               //                 ),
//               //               ),
//               //             ),
//               //           ),
//               //         ),
//               //       ])
//               //     : SizedBox(),

//               ///อันนี้คือรายการสั่งปริ๊น ที่ฟิกขนาดให้พอดีไว้เพื่อแคปรูป ตอนไปปริ๊น
//               // _finalListProducts.isNotEmpty
//               //     ? Column(
//               //         children: [
//               //           Center(
//               //             child: Text('ตัวอย่างการพิมพ์'),
//               //           ),
//               //           Padding(
//               //             padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
//               //             child: Card(
//               //               margin: EdgeInsets.zero,
//               //               elevation: 0,
//               //               color: Colors.white,
//               //               shape: RoundedRectangleBorder(
//               //                 side: BorderSide(
//               //                   color: Color.fromARGB(255, 238, 231, 231),
//               //                   width: 2.0,
//               //                 ),
//               //                 borderRadius: BorderRadius.circular(8),
//               //               ),
//               //               child: Padding(
//               //                 padding: EdgeInsets.all(8.0),
//               //                 child: RepaintBoundary(
//               //                   key: globalKey,
//               //                   child: Container(
//               //                     width: size.width * 0.60,
//               //                     color: Colors.white,
//               //                     child: Column(
//               //                       children: List.generate(
//               //                         _finalListProducts.length,
//               //                         (index) => Row(
//               //                           children: [
//               //                             Expanded(
//               //                                 flex: 7,
//               //                                 child: Text(
//               //                                   '${_finalListProducts[index].name}(x${_finalListProducts[index].qtyPack})',
//               //                                   style: TextStyle(fontSize: 16),
//               //                                 )),
//               //                             Expanded(
//               //                                 flex: 3,
//               //                                 child: Row(
//               //                                   mainAxisAlignment: MainAxisAlignment.end,
//               //                                   children: [
//               //                                     Text(
//               //                                       '${_finalListProducts[index].qty} ${_finalListProducts[index].unit}',
//               //                                       style: TextStyle(fontSize: 16),
//               //                                     ),
//               //                                   ],
//               //                                 )),
//               //                           ],
//               //                         ),
//               //                       ),
//               //                     ),
//               //                   ),
//               //                 ),
//               //               ),
//               //             ),
//               //           ),
//               //         ],
//               //       )
//               //     : SizedBox(),
//               SizedBox(
//                 height: size.height * 0.06,
//               ),
//               //โชวรูปภาพที่ได้จากการแคป
//               //pngBytes != null ? Image.memory(pngBytes!) : SizedBox()
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Visibility(
//         visible: true,
//         child: BottomAppBar(
//           height: size.height * 0.19,
//           clipBehavior: Clip.hardEdge,
//           shape: CircularNotchedRectangle(),
//           elevation: 25,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               enable == false
//                   ? InkWell(
//                       onTap: () async {
//                         _capturePngPag();
//                         if (pngBytesPag != null) {
//                           await PrinterService().print(widget.customer, pngBytesPag!);
//                           setState(() {
//                             enable = true;
//                           });
//                         } else {}
//                       },
//                       child: Container(
//                         decoration:
//                             BoxDecoration(color: kSecondaryColor, borderRadius: BorderRadius.all(Radius.circular(20))),
//                         height: size.height * 0.07,
//                         width: double.infinity,
//                         child: Center(
//                             child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'แพ็คของ',
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                           ],
//                         )),
//                       ),
//                     )
//                   : InkWell(
//                       onTap: () async {
//                         _capturePng();
//                         if (pngBytes != null) {
//                           items.clear();
//                           await PrinterService().print(widget.customer, pngBytes!);
//                           for (var i = 0; i < _finalListProducts.length; i++) {
//                             final item = Item(0, 0, 0, 0, 0, 0, 0);
//                             setState(() {
//                               item.itemId = _finalListProducts[i].id;
//                               item.qty = _finalListProducts[i].qty;
//                               item.unitItemId = _finalListProducts[i].unitId;
//                               item.bag = _finalListProducts[i].qtyPack;
//                               items.add(item);
//                             });
//                             //inspect(items);
//                           }
//                           // try {
//                           // LoadingDialog.open(context);
//                           // final order = await ProductApi.addOrderDarf(item: items, customer: widget.customer);
//                           // if (!mounted) return;
//                           // LoadingDialog.close(context);
//                           // if (order != null) {
//                           //   setState(() {
//                           //     _finalListProducts.clear();
//                           //     groupProduct.clear();
//                           //   });
//                           //   final ok = await showDialog(
//                           //     context: context,
//                           //     barrierDismissible: false,
//                           //     builder: (BuildContext context) {
//                           //       return AlertDialogYes(
//                           //         title: 'แจ้งเตือน',
//                           //         description: 'สร้างออร์เดอร์สำเร็จ',
//                           //         pressYes: () {
//                           //           Navigator.pop(context, true);
//                           //         },
//                           //       );
//                           //     },
//                           //   );
//                           //   if (ok == true) {
//                           //     if (_finalListProducts.isNotEmpty) {
//                           //       Navigator.pop(context, _finalListProducts);
//                           //     } else {
//                           //       Navigator.pop(context, null);
//                           //     }
//                           //   }
//                           //   } else {
//                           //     if (!mounted) return;
//                           //     LoadingDialog.close(context);
//                           //     showDialog(
//                           //       context: context,
//                           //       barrierDismissible: false,
//                           //       builder: (BuildContext context) {
//                           //         return AlertDialogYes(
//                           //           title: 'แจ้งเตือน',
//                           //           description: 'เกิดข้อผิดพลาด',
//                           //           pressYes: () {
//                           //             Navigator.pop(context, true);
//                           //           },
//                           //         );
//                           //       },
//                           //     );
//                           //   }
//                           // } on Exception catch (e) {
//                           //   if (!mounted) return;
//                           //   LoadingDialog.close(context);
//                           //   showDialog(
//                           //     context: context,
//                           //     barrierDismissible: false,
//                           //     builder: (BuildContext context) {
//                           //       return AlertDialogYes(
//                           //         title: 'แจ้งเตือน',
//                           //         description: '${e}',
//                           //         pressYes: () {
//                           //           Navigator.pop(context, true);
//                           //         },
//                           //       );
//                           //     },
//                           //   );
//                           // }

//                           //inspect(items);
//                         }
//                         //getCanvasImage('gogggggggggggggggggggggggggggggggggg');
//                         // if (_finalListProducts.isNotEmpty) {
//                         //   final newListProducts = _finalListProducts;
//                         //   for (var i = 0; i < newListProducts.length; i++) {
//                         //     newListProducts[i]['name'] = '${newListProducts[i]['name']}(x${newListProducts[i]['qtyPack']})';
//                         //     if (newListProducts[i]['name'].length < 17) {
//                         //       for (var j = 0; j < newListProducts[i]['name'].length; j++) {
//                         //         if (newListProducts[i]['name'].length < 17) {
//                         //           newListProducts[i]['name'] = '${newListProducts[i]['name']}' '  ';
//                         //         }
//                         //       }
//                         //     } else {
//                         //       newListProducts[i]['name'] = '${newListProducts[i]['name'].substring(0, 17)}(x${newListProducts[i]['qtyPack']})';
//                         //     }
//                         //   }
//                         //   //await PrinterService().print(widget.customer, newListProducts);
//                         //   setState(() {
//                         //     newListProducts.clear();
//                         //     _finalListProducts.clear();
//                         //     //widget.finalListProducts = reProducts;
//                         //     //widget.finalListProducts.clear();
//                         //   });
//                         // }
//                         // await PrinterService().print(widget.customer, _finalListProducts);

//                         // inspect(_finalListProducts);
//                       },
//                       child: Container(
//                         decoration:
//                             BoxDecoration(color: kSecondaryColor, borderRadius: BorderRadius.all(Radius.circular(20))),
//                         height: size.height * 0.07,
//                         width: double.infinity,
//                         child: Center(
//                             child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'ยืนยันรายการ',
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             // SizedBox(
//                             //   width: 50,
//                             //   height: 50,
//                             //   child: Image.asset('assets/icons/live.png'),
//                             // ),
//                           ],
//                         )),
//                       ),
//                     ),
//               InkWell(
//                 onTap: () async {
//                   setState(() {
//                     _finalListProducts.clear();
//                     groupProduct.clear();
//                   });
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(20))),
//                   height: size.height * 0.07,
//                   width: double.infinity,
//                   child: Center(
//                       child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'ลบรายการ',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       // SizedBox(
//                       //   width: 50,
//                       //   height: 50,
//                       //   child: Image.asset('assets/icons/live.png'),
//                       // ),
//                     ],
//                   )),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
