import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:android_id/android_id.dart';
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poshuasengheng/constants/constants.dart';
import 'package:poshuasengheng/extension/dateExtension.dart';
import 'package:poshuasengheng/models/customer.dart';
import 'package:poshuasengheng/models/groupproduct.dart';
import 'package:poshuasengheng/models/item.dart';
import 'package:poshuasengheng/models/priceUint.dart';
import 'package:poshuasengheng/models/product.dart';
import 'package:poshuasengheng/models/product2.dart';
import 'package:poshuasengheng/screen/printer/printerService.dart';
import 'package:poshuasengheng/screen/product/services/productApi.dart';
import 'package:poshuasengheng/screen/product/services/productController.dart';
import 'package:poshuasengheng/widgets/LoadingDialog.dart';
import 'package:poshuasengheng/widgets/inputNumberDialog.dart';
import 'package:poshuasengheng/widgets/materialDialog.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';

class CartProducts2 extends StatefulWidget {
  CartProducts2({super.key, required this.finalListProducts, required this.customer, required this.printer});
  List<Product2> finalListProducts;
  Customer customer;
  final String printer;

  @override
  State<CartProducts2> createState() => _CartProducts2State();
}

class _CartProducts2State extends State<CartProducts2> {
  final TextEditingController _myNumber = TextEditingController();
  int qty = 1;
  int qtyPack = 1;
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  List<Product2> _finalListProducts = [];
  List<Product> _newFinalListProducts = [];
  Image? img;
  GlobalKey globalKey = GlobalKey();
  Uint8List? pngBytes;
  Uint8List? pngBytesPag;
  String? bs64;
  bool show = false;
  List<Item> items = [];
  Map<String?, List<Product>>? newGroup;
  //List<GroupProduct>? groupProduct;
  List<MapEntry<String, List<Product2>>> groupProduct = [];
  bool enable = false;
  List<PriceUint> qtyPrice = [];
  List<Product2> product2 = [];
  String? deviceNo;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final controller = ScreenshotController();
  String ipAddress = '';
  String payQTY = '0';
  String payQTY2 = '';
  List<String> substrings = [];

  @override
  void initState() {
    super.initState();
    inspect(widget.finalListProducts);
    initialize();
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
      // final qty2 = await ProductApi.getListPriceUint(
      //   item: widget.finalListProducts,
      // );

      setState(() {
        product2 = widget.finalListProducts;
        printBinded = isBind!;
        _finalListProducts = widget.finalListProducts;
        if (product2.isNotEmpty) {
          groupProduct = groupBy(product2, (e) => '${e.name}').entries.toList();

          // inspect(groupProduct);
          // print(groupProduct[0].key);
          // print(groupProduct[0].value[0].qty);
          // print(groupProduct[1].key);
          // print(groupProduct[1].value[1].qty);
        }
        // inspect(groupProduct);
      });
    });
    getIp();
  }

  Future getIp() async {
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString('ipAddress');
    setState(() {
      ipAddress = ip!;
    });
  }

  Future<void> initialize() async {
    if (Platform.isAndroid) {
      final identifierId = await AndroidId().getId();
      setState(() {
        deviceNo = identifierId;
        inspect(deviceNo);
      });
    } else {
      final iosInfo = await deviceInfo.iosInfo;
      final identifierId = iosInfo.identifierForVendor;
      setState(() {
        deviceNo = identifierId;
        inspect(deviceNo);
      });
    }
  }

  // Future<void> priceUnit() async {
  //   // final qty = await context
  //   //     .read<ProductController>()
  //   //     .getPriceUint(widget.finalListProducts[i].id, widget.finalListProducts[i].qtyPack ?? 0);
  //   // inspect(qty);
  //   // setState(() {
  //   //   qtyPrice.add(qty);
  //   //   // inspect(qtyPrice);
  //   // });
  // }

  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  Future<void> testReceipt(NetworkPrinter printer, Uint8List bill, Uint8List customer) async {
    await PrinterService.printPOS(printer, customer, bill);
  }

  Future<void> testPrint(Uint8List bill, Uint8List customer) async {
    const PaperSize paper = PaperSize.mm80;
    // final profiles = await CapabilityProfile.getAvailableProfiles();
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    final printer = NetworkPrinter(paper, profile);
    // inspect(profiles);

    final PosPrintResult res = await printer.connect(ipAddress, port: 9100);

    if (res == PosPrintResult.success) {
      // DEMO RECEIPT
      // await printDemoReceipt(printer, refNo);
      // TEST PRINT
      // await testTicket(refNo: refNo);
      await testReceipt(printer, bill, customer);
    }

    // final snackBar = SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
    // Scaffold.of(ctx).showSnackBar(snackBar);
  }

  Future<Uint8List?> _capturePngPag() async {
    final orientation = MediaQuery.of(context).orientation;
    try {
      print('inside');
      RenderRepaintBoundary boundary1 = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary1.toImage(pixelRatio: 1.75);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      pngBytesPag = byteData!.buffer.asUint8List();
      bs64 = base64Encode(pngBytesPag!);
      // ui.Codec codec = await ui.instantiateImageCodec(pngBytes!);
      // ui.FrameInfo frame;
      // frame = await codec.getNextFrame();
      //await PrinterService().print(widget.customer, _finalListProducts, pngBytes!);
      print(pngBytesPag);
      print(bs64);
      setState(() {});
      return pngBytesPag;
    } catch (e) {
      print(e);
    }
  }

  Future<Uint8List?> _capturePng() async {
    final orientation = MediaQuery.of(context).orientation;
    try {
      print('inside');
      RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.75);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      pngBytes = byteData!.buffer.asUint8List();
      bs64 = base64Encode(pngBytes!);
      // ui.Codec codec = await ui.instantiateImageCodec(pngBytes!);
      // ui.FrameInfo frame;
      // frame = await codec.getNextFrame();
      //await PrinterService().print(widget.customer, _finalListProducts, pngBytes!);
      print(pngBytes);
      print(bs64);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer.asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  Future<Uint8List> _getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }

  // Future<void> printCapturedWidget(
  //   Uint8List capturedImage,
  //   String refNo,
  // ) async {
  //   final font = await rootBundle.load("fonts/Prompt-Regular.ttf");
  //   final ttf = pw.Font.ttf(font);
  //   final doc = pw.Document();
  //   // final directory = (await getApplicationDocumentsDirectory()).path;
  //   const title = 'รายการจัดส่งสินค้า';
  //   const store = 'ร้านค้า เล้าเซี่ยงเฮง';
  //   const tel = 'Tel. 02-225-2387\nTel. 02-225-1587';
  //   final customername = 'ชื่อ: ${widget.customer.name}';
  //   final customerlicensePage = 'ทะเบียนรถ: ${widget.customer.licensePage}';
  //   final date = 'วันที่: ${DateTime.now().formatTo('dd LLL y HH:mm น.')}';
  //   final _refNo = 'refNo: $refNo';
  //   // File myfile = File('$directory/qr.png');
  //   // final Uint8List byteList = await myfile.readAsBytes();
  //   // Uint8List byte = await _getImageFromAsset('assets/images/logo44.png');
  //   final image = await imageFromAssetBundle('assets/images/logo44.png');
  //   doc.addPage(
  //     pw.Page(
  //       build: (pw.Context context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           mainAxisAlignment: pw.MainAxisAlignment.start,
  //           mainAxisSize: pw.MainAxisSize.min,
  //           children: [
  //             pw.Center(
  //               child: pw.Image(
  //                 image,
  //                 width: 80,
  //                 height: 80,
  //               ),
  //             ),
  //             pw.Center(
  //               child: pw.Text(
  //                 title,
  //                 style: pw.TextStyle(
  //                   font: ttf,
  //                   fontSize: 10,
  //                 ),
  //               ),
  //             ),
  //             pw.Text(
  //               store,
  //               style: pw.TextStyle(
  //                 font: ttf,
  //                 fontSize: 10,
  //               ),
  //             ),
  //             pw.Text(
  //               tel,
  //               style: pw.TextStyle(
  //                 font: ttf,
  //                 fontSize: 10,
  //               ),
  //             ),
  //             pw.Divider(),
  //             pw.Text(
  //               customername,
  //               style: pw.TextStyle(
  //                 font: ttf,
  //                 fontSize: 10,
  //               ),
  //             ),
  //             pw.Text(
  //               customerlicensePage,
  //               style: pw.TextStyle(
  //                 font: ttf,
  //                 fontSize: 10,
  //               ),
  //             ),
  //             pw.Text(
  //               date,
  //               style: pw.TextStyle(
  //                 font: ttf,
  //                 fontSize: 10,
  //               ),
  //             ),
  //             pw.Text(
  //               _refNo,
  //               style: pw.TextStyle(
  //                 font: ttf,
  //                 fontSize: 10,
  //               ),
  //             ),
  //             pw.Divider(),
  //             pw.Image(
  //               pw.MemoryImage(
  //                 capturedImage,
  //               ),
  //               // fit: pw.BoxFit.cover,
  //             ),
  //           ],
  //         );
  //       },
  //       // pageFormat: PdfPageFormat.legal,
  //     ),
  //   );
  //   await Printing.layoutPdf(
  //     format: PdfPageFormat.roll80,
  //     usePrinterSettings: true,
  //     dynamicLayout: false,
  //     onLayout: (PdfPageFormat format) async {
  //       return doc.save();
  //     },
  //   );
  // }

  // Create a NumberFormat instance for Thai Baht currency formatting
  NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'th_TH', // Thai locale
    symbol: '', // Thai Baht symbol
  );

  double sum(List<Product2> product) => product.fold(
      0,
      (
        previous,
        o,
      ) =>
          previous + ((o.qty! * o.qtyPack!) * o.price!));

  double newtotal(Product2 orders) => double.parse(((orders.qty! * orders.qtyPack!) * orders.price!).toString());
  double sumQty(List<Product2> productQty) =>
      productQty.fold(0, (previousValue, element) => previousValue + double.parse(element.qty.toString()));
  double sumQtyPack(List<Product2> productQtyPack) =>
      productQtyPack.fold(0, (previousValue, element) => previousValue + double.parse(element.qtyPack.toString()));
  double sumPrice(List<Product2> productPrice) =>
      productPrice.fold(0, (previousValue, element) => previousValue + newtotal(element));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('รายการสินค้าในตะกร้า'),
        leading: IconButton(
            onPressed: () {
              if (product2.isNotEmpty) {
                Navigator.pop(context, product2);
              } else {
                Navigator.pop(context, null);
              }
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              groupProduct.isNotEmpty ? orderWidgetPrint('-') : SizedBox.shrink(),

              // Center(
              //   child: Text('ทะเบียนรถ: ${widget.customer.licensePage}',
              //       style: TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //       )),
              // ),
              // Center(
              //   child: Text('ชื่อลูกค้า: ${widget.customer.name}',
              //       style: TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //       )),
              // ),
              // Center(
              //   child: Text('เบอร์โทรศัพท์: ${widget.customer.tel}',
              //       style: TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //       )),
              // ),
              SizedBox(
                height: size.height * 0.02,
              ),
              product2.isNotEmpty
                  ? Column(
                      children: List.generate(
                          product2.length,
                          (index) => Card(
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.width * 0.01, vertical: size.width * 0.01),
                                          child: Column(
                                            children: [
                                              Text('${product2[index].name}'),
                                              product2[index].image != null
                                                  ? Image.network(
                                                      product2[index].image!,
                                                      fit: BoxFit.fill,
                                                      height: size.height * 0.12,
                                                      errorBuilder: (context, error, stackTrace) => Image.asset(
                                                        'assets/images/Screenshot.png',
                                                        height: size.height * 0.12,
                                                        width: size.height * 0.115,
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      'assets/images/Screenshot.png',
                                                      fit: BoxFit.fill,
                                                      height: size.height * 0.12,
                                                      width: size.height * 0.115,
                                                    ),
                                            ],
                                          ),
                                        )),
                                    Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.width * 0.01, vertical: size.height * 0.01),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Text(
                                              //   'จำนวน',
                                              //   style: TextStyle(fontSize: 14),
                                              // ),
                                              // Row(
                                              //   children: [
                                              //     InkWell(
                                              //       onTap: () {
                                              //         setState(() {
                                              //           if (product2[index].qty! > 1) {
                                              //             product2[index].qty = product2[index].qty! - 1;
                                              //           } else {}
                                              //         });
                                              //       },
                                              //       child: Container(
                                              //         decoration:
                                              //             BoxDecoration(border: Border.all(color: kDisableColor)),
                                              //         child: Icon(Icons.remove),
                                              //       ),
                                              //     ),
                                              //     Padding(
                                              //       padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                                              //       child: Container(
                                              //         decoration: BoxDecoration(
                                              //             border: Border.all(color: kDisableColor),
                                              //             color: Colors.white),
                                              //         width: size.width * 0.11,
                                              //         child: Center(
                                              //             child: Text(
                                              //           '${product2[index].qty}',
                                              //           style: TextStyle(fontSize: 15),
                                              //         )),
                                              //       ),
                                              //     ),
                                              //     InkWell(
                                              //       onTap: () {
                                              //         setState(() {
                                              //           product2[index].qty = product2[index].qty! + 1;
                                              //         });
                                              //       },
                                              //       child: Container(
                                              //         decoration:
                                              //             BoxDecoration(border: Border.all(color: kDisableColor)),
                                              //         child: Icon(Icons.add),
                                              //       ),
                                              //     ),
                                              //     // Padding(
                                              //     //   padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                                              //     //   child: Text('${_finalListProducts[index].unit}'),
                                              //     // )
                                              //   ],
                                              // ),
                                              // // Padding(
                                              // //   padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                                              // //   child: Text('ราคา ${product2[index].current_price_per_unit} บาท'),
                                              // // ),
                                              // Divider(),
                                              Text(
                                                'กิโลกรัม',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (product2[index].qtyPack! > 0.5) {
                                                          product2[index].qtyPack = product2[index].qtyPack! - 0.5;
                                                        } else {}
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration:
                                                          BoxDecoration(border: Border.all(color: kDisableColor)),
                                                      child: Icon(Icons.remove),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: kDisableColor),
                                                          color: Colors.white),
                                                      width: size.width * 0.11,
                                                      child: Center(
                                                          child: Text(
                                                        '${product2[index].qtyPack}',
                                                        style: TextStyle(fontSize: 15),
                                                      )),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        product2[index].qtyPack = product2[index].qtyPack! + 0.5;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration:
                                                          BoxDecoration(border: Border.all(color: kDisableColor)),
                                                      child: Icon(Icons.add),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                                                child: Text(
                                                    'ราคา ${product2[index].price} บาท'), //${qtyPrice[index].price_per_unit}
                                              ),
                                              // Divider(),
                                            ],
                                          ),
                                        )),
                                    enable == false
                                        ? Expanded(
                                            flex: 2,
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    product2.removeAt(index);
                                                    // _finalListProducts.removeAt(index);
                                                    if (product2.isNotEmpty) {
                                                      groupProduct =
                                                          groupBy(product2, (e) => '${e.name}').entries.toList();
                                                    } else {
                                                      groupProduct.clear();
                                                    }
                                                  });
                                                  //inspect(widget.finalListProducts);
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                  size: 32,
                                                )))
                                        : SizedBox.shrink()
                                  ],
                                ),
                              )),
                    )
                  : SizedBox(),
              SizedBox(
                height: size.height * 0.13,
              ),
              groupProduct.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Center(
                              child: Text('ตัวอย่างการพิมพ์'),
                            ),
                            buildBill2(),
                          ],
                        ),
                        Divider(
                          thickness: 2,
                          height: 2,
                          color: Colors.black,
                        ),
                        Column(
                          children: [
                            Text(
                              'ยอดชำระ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                              width: size.width * 0.3,
                              child: Center(
                                  child: TextField(
                                controller: _myNumber,
                                textAlign: TextAlign.center,
                                showCursor: false,
                                style: TextStyle(fontSize: 16.5),
                                // Disable the default soft keybaord
                                keyboardType: TextInputType.none,
                              )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            NumPad2(
                              buttonSize: 60,
                              buttonColor: Colors.grey,
                              iconColor: Colors.red,
                              controller: _myNumber,
                              // itemUnitPrices: products[index].itemUnitPrices!,
                              delete: () {
                                if (_myNumber.text != '') {
                                  if (_myNumber.text.length > 0) {
                                    _myNumber.text = _myNumber.text.substring(0, _myNumber.text.length - 1);
                                  }
                                }
                              },
                              // do something with the input numbers
                              onSubmit: () {
                                _myNumber.text != ''
                                    ? setState(() {
                                        payQTY = _myNumber.text;
                                        _myNumber.clear();
                                        enable = true;
                                        final qty = (int.parse(payQTY) - sum(product2));
                                        payQTY2 = qty.toStringAsFixed(2);
                                        List<String> _substrings = payQTY2.split('');
                                        substrings = _substrings;
                                        inspect(substrings);
                                      })
                                    : setState(() {
                                        enable = true;
                                        final qty = (int.parse(payQTY) - sum(product2));
                                        payQTY2 = qty.toStringAsFixed(2);
                                        List<String> _substrings = payQTY2.split('');
                                        substrings = _substrings;
                                        inspect(substrings);
                                      });
                                // debugPrint('Your code: ${_myNumber.text}');
                                // Navigator.pop(context, _myNumber.text);
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  : SizedBox(),

              ///อันนี้คือรายการสั่งปริ๊น ที่ฟิกขนาดให้พอดีไว้เพื่อแคปรูป ตอนไปปริ๊น
              // _finalListProducts.isNotEmpty
              //     ? Column(children: [
              //         Center(
              //           child: Text('ตัวอย่างการพิมพ์'),
              //         ),
              //         Padding(
              //           padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              //           child: Card(
              //             margin: EdgeInsets.zero,
              //             elevation: 0,
              //             color: Colors.white,
              //             shape: RoundedRectangleBorder(
              //               side: BorderSide(
              //                 color: Color.fromARGB(255, 238, 231, 231),
              //                 width: 2.0,
              //               ),
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //             child: Padding(
              //               padding: EdgeInsets.all(8.0),
              //               child: RepaintBoundary(
              //                 key: globalKey,
              //                 child: Container(
              //                   width: size.width * 0.60,
              //                   color: Colors.white,
              //                   child: Column(
              //                     children: [
              //                       Row(
              //                         children: [
              //                           Expanded(
              //                               flex: 7,
              //                               child: Text(
              //                                 'สินค้า',
              //                                 style: TextStyle(fontSize: 16),
              //                               )),
              //                           Expanded(
              //                               flex: 3,
              //                               child: Row(
              //                                 mainAxisAlignment: MainAxisAlignment.end,
              //                                 children: [
              //                                   Text(
              //                                     'ราคา',
              //                                     style: TextStyle(fontSize: 16),
              //                                   )
              //                                 ],
              //                               ))
              //                         ],
              //                       ),
              //                       Row(
              //                         children: [
              //                           Text(
              //                             'หน่วย xกิโล/หน่วย xราคา/กิโล',
              //                             style: TextStyle(fontSize: 13),
              //                           )
              //                         ],
              //                       ),
              //                       Column(
              //                         children: List.generate(
              //                             _finalListProducts.length,
              //                             (index) => Column(
              //                                   children: [
              //                                     Row(
              //                                       children: [
              //                                         Expanded(
              //                                             flex: 7,
              //                                             child: Text(
              //                                               '${_finalListProducts[index].name}',
              //                                               style: TextStyle(fontSize: 16),
              //                                             )),
              //                                         Expanded(
              //                                             flex: 3,
              //                                             child: Row(
              //                                               mainAxisAlignment: MainAxisAlignment.end,
              //                                               children: [
              //                                                 Text(
              //                                                   '${newtotal(_finalListProducts[index])}',
              //                                                   style: TextStyle(fontSize: 16),
              //                                                 )
              //                                               ],
              //                                             ))
              //                                       ],
              //                                     ),
              //                                     Row(
              //                                       children: [
              //                                         Text(
              //                                           '${_finalListProducts[index].qty} x${_finalListProducts[index].qtyPack} x${_finalListProducts[index].price}',
              //                                           style: TextStyle(fontSize: 13),
              //                                         )
              //                                       ],
              //                                     ),
              //                                   ],
              //                                 )),
              //                       ),
              //                       Divider(
              //                         thickness: 2,
              //                         height: 2,
              //                         color: Colors.black,
              //                       ),
              //                       Row(
              //                         children: [
              //                           Expanded(
              //                               flex: 7,
              //                               child: Text(
              //                                 'รวามรายการ',
              //                                 style: TextStyle(fontSize: 16),
              //                               )),
              //                           Expanded(
              //                               flex: 3,
              //                               child: Row(
              //                                 mainAxisAlignment: MainAxisAlignment.end,
              //                                 children: [
              //                                   Text(
              //                                     '1',
              //                                     style: TextStyle(fontSize: 16),
              //                                   )
              //                                 ],
              //                               ))
              //                         ],
              //                       ),
              //                       Divider(
              //                         thickness: 2,
              //                         height: 2,
              //                         color: Colors.black,
              //                       ),
              //                       Row(
              //                         children: [
              //                           Expanded(
              //                               flex: 7,
              //                               child: Text(
              //                                 'รวมเป็น',
              //                                 style: TextStyle(fontSize: 16),
              //                               )),
              //                           Expanded(
              //                               flex: 3,
              //                               child: Row(
              //                                 mainAxisAlignment: MainAxisAlignment.end,
              //                                 children: [
              //                                   Text(
              //                                     '${sum(_finalListProducts)}',
              //                                     style: TextStyle(fontSize: 16),
              //                                   )
              //                                 ],
              //                               ))
              //                         ],
              //                       ),
              //                       Row(
              //                         children: [
              //                           Expanded(
              //                               flex: 7,
              //                               child: Text(
              //                                 'ยอดค้าง',
              //                                 style: TextStyle(fontSize: 16),
              //                               )),
              //                           Expanded(
              //                               flex: 3,
              //                               child: Row(
              //                                 mainAxisAlignment: MainAxisAlignment.end,
              //                                 children: [
              //                                   Text(
              //                                     '0',
              //                                     style: TextStyle(fontSize: 16),
              //                                   )
              //                                 ],
              //                               ))
              //                         ],
              //                       ),
              //                       Row(
              //                         children: [
              //                           Expanded(
              //                               flex: 7,
              //                               child: Text(
              //                                 'ยอดชำระ',
              //                                 style: TextStyle(fontSize: 16),
              //                               )),
              //                           Expanded(
              //                               flex: 3,
              //                               child: Row(
              //                                 mainAxisAlignment: MainAxisAlignment.end,
              //                                 children: [
              //                                   Text(
              //                                     '0',
              //                                     style: TextStyle(fontSize: 16),
              //                                   )
              //                                 ],
              //                               ))
              //                         ],
              //                       ),
              //                       Row(
              //                         children: [
              //                           Expanded(
              //                               flex: 7,
              //                               child: Text(
              //                                 'รวมค้าง',
              //                                 style: TextStyle(fontSize: 16),
              //                               )),
              //                           Expanded(
              //                               flex: 3,
              //                               child: Row(
              //                                 mainAxisAlignment: MainAxisAlignment.end,
              //                                 children: [
              //                                   Text(
              //                                     '${sum(_finalListProducts)}',
              //                                     style: TextStyle(fontSize: 16),
              //                                   )
              //                                 ],
              //                               ))
              //                         ],
              //                       ),
              //                       Row(
              //                         children: [
              //                           Expanded(
              //                               flex: 7,
              //                               child: Text(
              //                                 'ทอน',
              //                                 style: TextStyle(fontSize: 16),
              //                               )),
              //                           Expanded(
              //                               flex: 3,
              //                               child: Row(
              //                                 mainAxisAlignment: MainAxisAlignment.end,
              //                                 children: [
              //                                   Text(
              //                                     '0',
              //                                     style: TextStyle(fontSize: 16),
              //                                   )
              //                                 ],
              //                               ))
              //                         ],
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ])
              //     : SizedBox(),

              ///อันนี้คือรายการสั่งปริ๊น ที่ฟิกขนาดให้พอดีไว้เพื่อแคปรูป ตอนไปปริ๊น
              // _finalListProducts.isNotEmpty
              //     ? Column(
              //         children: [
              //           Center(
              //             child: Text('ตัวอย่างการพิมพ์'),
              //           ),
              //           Padding(
              //             padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              //             child: Card(
              //               margin: EdgeInsets.zero,
              //               elevation: 0,
              //               color: Colors.white,
              //               shape: RoundedRectangleBorder(
              //                 side: BorderSide(
              //                   color: Color.fromARGB(255, 238, 231, 231),
              //                   width: 2.0,
              //                 ),
              //                 borderRadius: BorderRadius.circular(8),
              //               ),
              //               child: Padding(
              //                 padding: EdgeInsets.all(8.0),
              //                 child: RepaintBoundary(
              //                   key: globalKey,
              //                   child: Container(
              //                     width: size.width * 0.60,
              //                     color: Colors.white,
              //                     child: Column(
              //                       children: List.generate(
              //                         _finalListProducts.length,
              //                         (index) => Row(
              //                           children: [
              //                             Expanded(
              //                                 flex: 7,
              //                                 child: Text(
              //                                   '${_finalListProducts[index].name}(x${_finalListProducts[index].qtyPack})',
              //                                   style: TextStyle(fontSize: 16),
              //                                 )),
              //                             Expanded(
              //                                 flex: 3,
              //                                 child: Row(
              //                                   mainAxisAlignment: MainAxisAlignment.end,
              //                                   children: [
              //                                     Text(
              //                                       '${_finalListProducts[index].qty} ${_finalListProducts[index].unit}',
              //                                       style: TextStyle(fontSize: 16),
              //                                     ),
              //                                   ],
              //                                 )),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       )
              //     : SizedBox(),
              SizedBox(
                height: size.height * 0.06,
              ),
              //โชวรูปภาพที่ได้จากการแคป
              //pngBytes != null ? Image.memory(pngBytes!) : SizedBox()
            ],
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: true,
        child: BottomAppBar(
          height: size.height * 0.19,
          clipBehavior: Clip.hardEdge,
          shape: CircularNotchedRectangle(),
          elevation: 25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              enable == false
                  ? InkWell(
                      onTap: () async {
                        await _capturePngPag();
                        if (pngBytesPag != null) {
                          // await PrinterService().print(widget.customer, pngBytesPag!);
                          setState(() {
                            enable = true;
                            final qty = (int.parse(payQTY) - sum(product2));
                            payQTY2 = qty.toStringAsFixed(2);
                            List<String> _substrings = payQTY2.split('');
                            substrings = _substrings;
                            inspect(substrings);
                          });
                        } else {}
                      },
                      child: Container(
                        decoration:
                            BoxDecoration(color: kSecondaryColor, borderRadius: BorderRadius.all(Radius.circular(20))),
                        height: size.height * 0.07,
                        width: double.infinity,
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'แพ็คของ',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        )),
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        await _capturePng();
                        if (pngBytes != null) {
                          // await printCapturedWidget(pngBytes!, ' order.refNo!');
                          // final qrCode = await controller.captureFromWidget(order('fsdfds'));
                          // testPrint( pngBytes!, qrCode);
                          // printTicket(testTicket(refNo: 'fdsfsdf'));
                          // printCapturedWidget(pngBytes!, 'order.refNo!');
                          // items.clear();
                          for (var i = 0; i < product2.length; i++) {
                            final item = Item('', 0, 0, true, 0, 0, 0, '', '', 0, 0);
                            setState(() {
                              item.id = product2[i].id;
                              item.name = product2[i].name;
                              item.qty = product2[i].qty;
                              item.unitItemId = product2[i].unitId;
                              item.bag = product2[i].qtyPack;
                              item.price = product2[i].price;
                              item.sum = product2[i].price! * product2[i].qtyPack!;
                              item.type = 'product';
                              item.code = product2[i].code;
                              items.add(item);
                            });
                            inspect(items);
                          }
                          try {
                            LoadingDialog.open(context);
                            final order = await ProductApi.addOrder(
                              item: items,
                              pay: int.parse(payQTY),
                              customer: widget.customer,
                              total: double.parse(sum(product2).toStringAsFixed(2)),
                              price: double.parse(sum(product2).toStringAsFixed(2)),
                            );
                            if (!mounted) return;
                            LoadingDialog.close(context);
                            if (order != null) {
                              if (!mounted) return;
                              final ok = await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialogYes(
                                    title: 'แจ้งเตือน',
                                    description: 'สร้างออร์เดอร์สำเร็จ',
                                    pressYes: () {
                                      Navigator.pop(context, true);
                                    },
                                  );
                                },
                              );
                              if (widget.printer != 'NOT FOUND') {
                                await PrinterService().print(widget.customer, pngBytes!, order.refNo!);
                              } else {
                                // await printCapturedWidget(pngBytes!, order.refNo!);
                                // final qrCode = await controller.captureFromWidget(buildBill());
                                // printCapturedWidget(qrCode);
                                final qrCode = await controller.captureFromWidget(orderWidget(order.refNo!));
                                testPrint(pngBytes!, qrCode);
                              }
                              setState(() {
                                product2.clear();
                                _finalListProducts.clear();
                                groupProduct.clear();
                              });
                              if (ok == true) {
                                if (_finalListProducts.isNotEmpty) {
                                  Navigator.pop(context, _finalListProducts);
                                } else {
                                  Navigator.pop(context, null);
                                }
                              }
                            } else {
                              if (!mounted) return;
                              LoadingDialog.close(context);
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialogYes(
                                    title: 'แจ้งเตือน',
                                    description: 'เกิดข้อผิดพลาด',
                                    pressYes: () {
                                      Navigator.pop(context, true);
                                    },
                                  );
                                },
                              );
                            }
                          } on Exception catch (e) {
                            if (!mounted) return;
                            LoadingDialog.close(context);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialogYes(
                                  title: 'แจ้งเตือน',
                                  description: '$e',
                                  pressYes: () {
                                    Navigator.pop(context, true);
                                  },
                                );
                              },
                            );
                          }

                          //inspect(items);
                        }
                        //getCanvasImage('gogggggggggggggggggggggggggggggggggg');
                        // if (_finalListProducts.isNotEmpty) {
                        //   final newListProducts = _finalListProducts;
                        //   for (var i = 0; i < newListProducts.length; i++) {
                        //     newListProducts[i]['name'] = '${newListProducts[i]['name']}(x${newListProducts[i]['qtyPack']})';
                        //     if (newListProducts[i]['name'].length < 17) {
                        //       for (var j = 0; j < newListProducts[i]['name'].length; j++) {
                        //         if (newListProducts[i]['name'].length < 17) {
                        //           newListProducts[i]['name'] = '${newListProducts[i]['name']}' '  ';
                        //         }
                        //       }
                        //     } else {
                        //       newListProducts[i]['name'] = '${newListProducts[i]['name'].substring(0, 17)}(x${newListProducts[i]['qtyPack']})';
                        //     }
                        //   }
                        //   //await PrinterService().print(widget.customer, newListProducts);
                        //   setState(() {
                        //     newListProducts.clear();
                        //     _finalListProducts.clear();
                        //     //widget.finalListProducts = reProducts;
                        //     //widget.finalListProducts.clear();
                        //   });
                        // }
                        // await PrinterService().print(widget.customer, _finalListProducts);

                        // inspect(_finalListProducts);
                      },
                      child: Container(
                        decoration:
                            BoxDecoration(color: kSecondaryColor, borderRadius: BorderRadius.all(Radius.circular(20))),
                        height: size.height * 0.07,
                        width: double.infinity,
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
              InkWell(
                onTap: () async {
                  setState(() {
                    product2.clear();
                    _finalListProducts.clear();
                    groupProduct.clear();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(20))),
                  height: size.height * 0.07,
                  width: double.infinity,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ลบรายการ',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBill2() {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    return Screenshot(
      controller: controller,
      child: SizedBox(
        width: size.width * 0.75,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Card(
            // margin: EdgeInsets.zero,
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color.fromARGB(255, 238, 231, 231),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RepaintBoundary(
                key: globalKey,
                child: Container(
                  // width: size.width * 0.5,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'สินค้า',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'ราคา',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                      Text(
                        'หน่วย xกิโล/หน่วย xราคา/กิโล',
                        style: TextStyle(fontSize: 14),
                      ),
                      Column(
                        children: List.generate(
                            groupProduct.length,
                            (index) => Column(
                                  children: [
                                    Row(
                                      // mainAxisAlignment: orientation == Orientation.portrait
                                      //     ? MainAxisAlignment.start
                                      //     : MainAxisAlignment.spaceBetween,
                                      children: [
                                        // ${sumQty(groupProduct[index].value).toInt()} x ${int.parse(sumQtyPack(groupProduct[index].value).round().toString())}
                                        Text(
                                          groupProduct[index].key,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        // orientation != Orientation.portrait
                                        //     ? SizedBox(
                                        //         width: 100,
                                        //         child: Column(
                                        //           children: List.generate(
                                        //             1,
                                        //             (index2) => Row(
                                        //               mainAxisAlignment: MainAxisAlignment.start,
                                        //               children: [
                                        //                 Text(
                                        //                   '${num.parse(sumQtyPack(groupProduct[index].value).toString()).toStringAsFixed(2)} x ${groupProduct[index].value[index2].price}',
                                        //                   style: TextStyle(fontSize: 13),
                                        //                 ),
                                        //               ],
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       )
                                        //     : SizedBox.shrink(),
                                        // orientation != Orientation.portrait
                                        //     ? SizedBox(
                                        //         width: 100,
                                        //         child: Row(
                                        //           mainAxisAlignment: MainAxisAlignment.end,
                                        //           children: [
                                        //             enable == false
                                        //                 ? Text('')
                                        //                 : Text(
                                        //                     '= ${sumPrice(groupProduct[index].value).toStringAsFixed(2)}',
                                        //                     style: TextStyle(fontSize: 13),
                                        //                   ),
                                        //             // : Text(
                                        //             //     'รวม ${currencyFormat.format(sumPrice(groupProduct[index].value))}'),
                                        //             //Text('${sumPrice(groupProduct[index].value)}'),
                                        //           ],
                                        //         ),
                                        //       )
                                        //     : SizedBox.shrink(),
                                      ],
                                    ),
                                    //  Row(
                                    //   children: [
                                    //     Row(
                                    //       children: List.generate(
                                    //         groupProduct[index].value.length,
                                    //         (index2) => Row(
                                    //           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //           children: [
                                    //             Text(
                                    //               ' + (${groupProduct[index].value[index2].qty} x ${groupProduct[index].value[index2].qtyPack})',
                                    //             ),
                                    //             // Expanded(
                                    //             //     flex: 4,
                                    //             //     child: Row(
                                    //             //       mainAxisAlignment: MainAxisAlignment.end,
                                    //             //       children: [
                                    //             //         enable == false
                                    //             //             ? Text('')
                                    //             //             : Text(
                                    //             //                 '${newtotal(groupProduct[index].value[index2]).toInt()}'),
                                    //             //         // : Text(
                                    //             //         //     '${currencyFormat.format(newtotal(groupProduct[index].value[index2]))}'),
                                    //             //       ],
                                    //             //     )),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Text(' x ${groupProduct[0].value[0].current_price_per_unit}'),
                                    //   ],
                                    // ),
                                    Row(
                                      children: List.generate(
                                        groupProduct[index].value.length,
                                        (index2) => Flexible(
                                          flex: 7,
                                          child: Text(
                                            '${groupProduct[index].value[index2] == groupProduct[index].value[0] ? '' : '+'}${groupProduct[index].value[index2].qtyPack}',
                                            style: TextStyle(fontSize: 9),
                                            maxLines: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Row(
                                    //   children: List.generate(
                                    //     groupProduct[index].value.length,
                                    //     (index2) => Flexible(
                                    //       fit: FlexFit.tight,
                                    //       child: Row(
                                    //         children: [
                                    //           Text(
                                    //             groupProduct[index].value[index2] ==
                                    //                     groupProduct[index].value[0]
                                    //                 ? ''
                                    //                 : '+',
                                    //             style: TextStyle(fontSize: 9),
                                    //           ),
                                    //           Flexible(
                                    //             child: Text(
                                    //               '${groupProduct[index].value[index2].qtyPack}',
                                    //               style: TextStyle(fontSize: 10),
                                    //               maxLines: 10,
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Column(
                                      children: List.generate(
                                        1,
                                        (index2) => Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '= ${num.parse(sumQtyPack(groupProduct[index].value).toString()).toStringAsFixed(2)} x ${groupProduct[index].value[index2].price}',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     // ${sumQty(groupProduct[index].value).toInt()} x
                                    //     Text(
                                    //         '= ${num.parse(sumQtyPack(groupProduct[index].value).toString())} x ${groupProduct[index].value[index].price}'),
                                    //   ],
                                    // ),
                                    //// ผลรวมแยก
                                    // Column(
                                    //   children: List.generate(
                                    //     groupProduct[index].value.length,
                                    //     (index2) => Row(
                                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //       children: [
                                    //         Expanded(
                                    //           flex: 6,
                                    //           child: Text(
                                    //               '(${groupProduct[index].value[index2].qty} x ${groupProduct[index].value[index2].qtyPack}) x ${groupProduct[index].value[index2].current_price_per_unit}'), //${groupProduct[index].value[index2].price}${qtyPrice[index2].price_per_unit}
                                    //         ),
                                    //         Expanded(
                                    //             flex: 4,
                                    //             child: Row(
                                    //               mainAxisAlignment: MainAxisAlignment.end,
                                    //               children: [
                                    //                 enable == false
                                    //                     ? Text('')
                                    //                     : Text(
                                    //                         '${newtotal(groupProduct[index].value[index2]).toInt()}'),
                                    //                 // : Text(
                                    //                 //     '${currencyFormat.format(newtotal(groupProduct[index].value[index2]))}'),
                                    //               ],
                                    //             )),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        enable == false
                                            ? Text('')
                                            : Text(
                                                '= ${sumPrice(groupProduct[index].value).toStringAsFixed(2)}',
                                                style: TextStyle(fontSize: 13),
                                              ),
                                        // : Text(
                                        //     'รวม ${currencyFormat.format(sumPrice(groupProduct[index].value))}'),
                                        //Text('${sumPrice(groupProduct[index].value)}'),
                                      ],
                                    )
                                  ],
                                )),
                      ),
                      Divider(
                        thickness: 2,
                        height: 2,
                        color: Colors.black,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Text(
                                'รวมรายการ',
                                style: TextStyle(fontSize: 14),
                              )),
                          // Expanded(
                          //     flex: 5,
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.end,
                          //       children: [
                          //         Text(
                          //           '1',
                          //           style: TextStyle(fontSize: 16),
                          //         )
                          //       ],
                          //     ))
                        ],
                      ),
                      Divider(
                        thickness: 2,
                        height: 2,
                        color: Colors.black,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Text(
                                'รวมเป็น',
                                style: TextStyle(fontSize: 14),
                              )),
                          Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  enable == false
                                      ? Text(
                                          int.parse('0').toStringAsFixed(2),
                                          style: TextStyle(fontSize: 14),
                                        )
                                      : Text(
                                          sum(product2).toStringAsFixed(2),
                                          // : Text(
                                          //     '${currencyFormat.format(sum(product2))}',
                                          style: TextStyle(fontSize: 14),
                                        )
                                ],
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Text(
                                'ยอดชำระ',
                                style: TextStyle(fontSize: 14),
                              )),
                          Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  payQTY == ''
                                      ? Text(
                                          int.parse('0').toStringAsFixed(2),
                                          style: TextStyle(fontSize: 14),
                                        )
                                      : Text(
                                          int.parse(payQTY).toStringAsFixed(2),
                                          style: TextStyle(fontSize: 14),
                                        )
                                ],
                              ))
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //         flex: 5,
                      //         child: Text(
                      //           'รวมค้าง',
                      //           style: TextStyle(fontSize: 14),
                      //         )),
                      //     Expanded(
                      //         flex: 5,
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.end,
                      //           children: [
                      //             enable == false
                      //                 ? Text(
                      //                     '0',
                      //                     style: TextStyle(fontSize: 14),
                      //                   )
                      //                 : Text(
                      //                     sum(product2).toStringAsFixed(2),
                      //                     style: TextStyle(fontSize: 14),
                      //                   )
                      //             // : Text(
                      //             //     '${currencyFormat.format(sum(product2))}',
                      //             //     style: TextStyle(fontSize: 16),
                      //             //   )
                      //           ],
                      //         ))
                      //   ],
                      // ),
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Text(
                                'ยอดค้าง',
                                style: TextStyle(fontSize: 14),
                              )),
                          Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  substrings.isNotEmpty
                                      ? substrings[0] != '-'
                                          ? Text(
                                              int.parse('0').toStringAsFixed(2),
                                              style: TextStyle(fontSize: 14),
                                            )
                                          : payQTY2 == ''
                                              ? Text(
                                                  int.parse('0').toStringAsFixed(2),
                                                  style: TextStyle(fontSize: 14),
                                                )
                                              : Text(
                                                  payQTY2,
                                                  style: TextStyle(fontSize: 14),
                                                )
                                      : Text(
                                          int.parse('0').toStringAsFixed(2),
                                          style: TextStyle(fontSize: 14),
                                        )
                                ],
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Text(
                                'ทอน',
                                style: TextStyle(fontSize: 14),
                              )),
                          Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  substrings.isNotEmpty
                                      ? substrings[0] == '-'
                                          ? Text(
                                              int.parse('0').toStringAsFixed(2),
                                              style: TextStyle(fontSize: 14),
                                            )
                                          : payQTY2 == ''
                                              ? Text(
                                                  int.parse('0').toStringAsFixed(2),
                                                  style: TextStyle(fontSize: 14),
                                                )
                                              : Text(
                                                  payQTY2,
                                                  style: TextStyle(fontSize: 14),
                                                )
                                      : Text(
                                          int.parse('0').toStringAsFixed(2),
                                          style: TextStyle(fontSize: 14),
                                        )
                                ],
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget orderWidget(String refNo) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      width: size.width * 0.75,
      // height: orientation == Orientation.portrait ? size.width * 0.28 : size.width * 0.18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color.fromARGB(255, 238, 231, 231),
        ),
      ),
      // color: Colors.green,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'รายการจัดส่งสินค้า',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Text(
            'ร้านค้า เล้าเซี่ยงเฮง',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Text(
            'โทร 02-225-2387\nโทร 02-225-1587',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Divider(
            color: Colors.black,
          ),
          Text(
            'ชื่อ: ${widget.customer.name}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Text(
            'ทะเบียนรถ: ${widget.customer.licensePage}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Text(
            'วันที่: ${DateTime.now().formatTo('dd LLL y HH:mm น.')}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Text(
            'refNo: $refNo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget orderWidgetPrint(String refNo) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      width: size.width * 0.75,
      // height: orientation == Orientation.portrait ? size.width * 0.35 : size.width * 0.22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color.fromARGB(255, 238, 231, 231),
        ),
      ),
      // color: Colors.green,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'รายการจัดส่งสินค้า',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Text(
            'ร้านค้า เล้าเซี่ยงเฮง',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Text(
            'โทร 02-225-2387\nโทร 02-225-1587',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Divider(
            color: Colors.black,
          ),
          Text(
            'ชื่อ: ${widget.customer.name}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Text(
            'ทะเบียนรถ: ${widget.customer.licensePage}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Text(
            'วันที่: ${DateTime.now().formatTo('dd LLL y HH:mm น.')}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Text(
            'refNo: $refNo',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
