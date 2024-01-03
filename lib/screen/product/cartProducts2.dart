import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:android_id/android_id.dart';
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
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
import 'package:poshuasengheng/widgets/materialDialog.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class CartProducts2 extends StatefulWidget {
  CartProducts2({super.key, required this.finalListProducts, required this.customer, required this.printer});
  List<Product2> finalListProducts;
  Customer customer;
  final String printer;

  @override
  State<CartProducts2> createState() => _CartProducts2State();
}

class _CartProducts2State extends State<CartProducts2> {
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

  // Future<List<int>> testTicket({
  //   String? refNo,
  // }) async {
  //   final profile = await CapabilityProfile.load();
  //   final generator = Generator(PaperSize.mm58, profile);
  //   List<int> bytes = [];

  //   bytes += generator.text('Tel. 02-225-2387\nTel. 02-225-1587', styles: PosStyles(align: PosAlign.center));
  //   bytes += generator.text('ชื่อ: ${widget.customer.name}', styles: PosStyles(align: PosAlign.center));
  //   bytes += generator.text('ทะเบียนรถ: ${widget.customer.licensePage}', styles: PosStyles(align: PosAlign.center));
  //   bytes += generator.text('วันที่: ${DateTime.now().formatTo('dd LLL y HH:mm น.')}',
  //       styles: PosStyles(align: PosAlign.center));
  //   bytes += generator.text('refNo: $refNo', styles: PosStyles(align: PosAlign.center));

  //   bytes += generator.row([
  //     PosColumn(
  //       text: 'col3',
  //       width: 3,
  //       styles: const PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'col6',
  //       width: 6,
  //       styles: const PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'col3',
  //       width: 3,
  //       styles: const PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //   ]);

  //   bytes += generator.text('Text size 200%',
  //       styles: const PosStyles(
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ));

  //   // Print barcode
  //   final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
  //   bytes += generator.barcode(Barcode.upcA(barData));

  //   bytes += generator.feed(2);
  //   bytes += generator.cut();
  //   return bytes;
  // }

  // Future<List<int>> testTicket(
  //   // NetworkPrinter printer,
  //   String refNo,
  // ) async {
  //   // Print image
  //   List<int> bytes2 = [];
  //   final profile = await CapabilityProfile.load();
  //   final generator = Generator(PaperSize.mm80, profile);
  //   final ByteData data = await rootBundle.load('assets/images/Screenshot.png');
  //   final Uint8List bytes = data.buffer.asUint8List();
  //   Image image = Image.memory(bytes);
  //   // printer.image(image!);
  //   // bytes2 += generator.image(image);

  //   bytes2 += generator.text('ร้านค้า เล้าเซี่ยงเฮง',
  //       styles: PosStyles(
  //         align: PosAlign.center,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ),
  //       linesAfter: 1);

  //   bytes2 += generator.text('Tel. 02-225-2387\nTel. 02-225-1587', styles: PosStyles(align: PosAlign.center));
  //   bytes2 += generator.text('ชื่อ: ${widget.customer.name}', styles: PosStyles(align: PosAlign.center));
  //   bytes2 += generator.text('ทะเบียนรถ: ${widget.customer.licensePage}', styles: PosStyles(align: PosAlign.center));
  //   bytes2 += generator.text('วันที่: ${DateTime.now().formatTo('dd LLL y HH:mm น.')}',
  //       styles: PosStyles(align: PosAlign.center));
  //   bytes2 += generator.text('refNo: $refNo', styles: PosStyles(align: PosAlign.center));
  //   // bytes2 += generator.text('Web: www.example.com', styles: PosStyles(align: PosAlign.center), linesAfter: 1);

  //   bytes2 += generator.hr();
  //   bytes2 += generator.row([
  //     PosColumn(text: 'Qty', width: 1),
  //     PosColumn(text: 'Item', width: 7),
  //     PosColumn(text: 'Price', width: 2, styles: PosStyles(align: PosAlign.right)),
  //     PosColumn(text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);

  //   bytes2 += generator.hr();

  //   // bytes2 += generator.row([
  //   //   PosColumn(
  //   //       text: 'TOTAL',
  //   //       width: 6,
  //   //       styles: PosStyles(
  //   //         height: PosTextSize.size2,
  //   //         width: PosTextSize.size2,
  //   //       )),
  //   //   PosColumn(
  //   //       text: '\$10.97',
  //   //       width: 6,
  //   //       styles: PosStyles(
  //   //         align: PosAlign.right,
  //   //         height: PosTextSize.size2,
  //   //         width: PosTextSize.size2,
  //   //       )),
  //   // ]);

  //   bytes2 += generator.hr(ch: '=', linesAfter: 1);

  //   // bytes2 += generator.row([
  //   //   PosColumn(text: 'Cash', width: 8, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
  //   //   PosColumn(text: '\$15.00', width: 4, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
  //   // ]);
  //   // bytes2 += generator.row([
  //   //   PosColumn(text: 'Change', width: 8, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
  //   //   PosColumn(text: '\$4.03', width: 4, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
  //   // ]);

  //   bytes2 += generator.feed(2);
  //   bytes2 += generator.text('Thank you!', styles: PosStyles(align: PosAlign.center, bold: true));

  //   // final now = DateTime.now();
  //   // final formatter = DateFormat('MM/dd/yyyy H:m');
  //   // final String timestamp = formatter.format(now);
  //   // bytes2 += generator.text(timestamp, styles: PosStyles(align: PosAlign.center), linesAfter: 2);

  //   // Print QR Code from image
  //   // try {
  //   //   const String qrData = 'example.com';
  //   //   const double qrSize = 200;
  //   //   final uiImg = await QrPainter(
  //   //     data: qrData,
  //   //     version: QrVersions.auto,
  //   //     gapless: false,
  //   //   ).toImageData(qrSize);
  //   //   final dir = await getTemporaryDirectory();
  //   //   final pathName = '${dir.path}/qr_tmp.png';
  //   //   final qrFile = File(pathName);
  //   //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
  //   //   final img = decodeImage(imgFile.readAsBytesSync());

  //   //      bytes2 += generator.image(img);
  //   // } catch (e) {
  //   //   print(e);
  //   // }

  //   // Print QR Code using native function
  //   //    bytes2 += generator.qrcode('example.com');

  //   bytes2 += generator.feed(1);
  //   bytes2 += generator.cut();
  // }

  // Future<void> printTicket(List<int> ticket) async {
  //   final printer = PrinterNetworkManager('192.168.1.122');
  //   PosPrintResult connect = await printer.connect();
  //   if (connect == PosPrintResult.success) {
  //     PosPrintResult printing = await printer.printTicket(ticket);

  //     print(printing.msg);
  //     printer.disconnect();
  //   }
  // }

  // void testPrint(
  //   String printerIp,
  //   String refNo,
  // ) async {
  //   // TODO Don't forget to choose printer's paper size
  //   const PaperSize paper = PaperSize.mm80;
  //   final profile = await CapabilityProfile.load();
  //   final printer = NetworkPrinter(paper, profile);

  //   final PosPrintResult res = await printer.connect(printerIp, port: 9100);

  //   if (res == PosPrintResult.success) {
  //     // DEMO RECEIPT
  //     await printDemoReceipt(printer, refNo);
  //     // TEST PRINT
  //     // await testReceipt(printer);
  //     printer.disconnect();
  //   }

  //   final snackBar = SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
  //   // Scaffold.of(ctx).showSnackBar(snackBar);
  // }

  Future<Uint8List?> _capturePngPag() async {
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

  Future<void> printCapturedWidget(
    Uint8List capturedImage,
    String refNo,
  ) async {
    final font = await rootBundle.load("fonts/Prompt-Regular.ttf");
    final ttf = pw.Font.ttf(font);
    final doc = pw.Document();
    // final directory = (await getApplicationDocumentsDirectory()).path;
    const title = 'รายการจัดส่งสินค้า';
    const store = 'ร้านค้า เล้าเซี่ยงเฮง';
    const tel = 'Tel. 02-225-2387\nTel. 02-225-1587';
    final customername = 'ชื่อ: ${widget.customer.name}';
    final customerlicensePage = 'ทะเบียนรถ: ${widget.customer.licensePage}';
    final date = 'วันที่: ${DateTime.now().formatTo('dd LLL y HH:mm น.')}';
    final _refNo = 'refNo: $refNo';
    // File myfile = File('$directory/qr.png');
    // final Uint8List byteList = await myfile.readAsBytes();
    Uint8List byte = await _getImageFromAsset('assets/images/logo44.png');
    doc.addPage(pw.Page(build: (pw.Context context) {
      return pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Center(
              child: pw.Image(
                pw.MemoryImage(byte),
                width: 80,
                height: 80,
              ),
            ),
            pw.Center(
              child: pw.Text(
                title,
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 10,
                ),
              ),
            ),
            pw.Text(
              store,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 10,
              ),
            ),
            pw.Text(
              tel,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 10,
              ),
            ),
            pw.Divider(),
            pw.Text(
              customername,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 10,
              ),
            ),
            pw.Text(
              customerlicensePage,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 10,
              ),
            ),
            pw.Text(
              date,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 10,
              ),
            ),
            pw.Text(
              _refNo,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 10,
              ),
            ),
            pw.Divider(),
            pw.Image(
              pw.MemoryImage(
                capturedImage,
              ),
              // fit: pw.BoxFit.cover,
            ),
          ],
        ),
      );
    }));
    await Printing.layoutPdf(
      format: PdfPageFormat.roll57,
      usePrinterSettings: true,
      dynamicLayout: false,
      onLayout: (PdfPageFormat format) async {
        return doc.save();
      },
    );
  }

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
              Center(
                child: Text('ทะเบียนรถ: ${widget.customer.licensePage}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Center(
                child: Text('ชื่อลูกค้า: ${widget.customer.name}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Center(
                child: Text('เบอร์โทรศัพท์: ${widget.customer.tel}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
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
                      children: [
                        Center(
                          child: Text('ตัวอย่างการพิมพ์'),
                        ),
                        buildBill2(),
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
                          items.clear();
                          // testPrint('192.168.1.122', 'fsdfsdfds');
                          // printTicket(testTicket(refNo: 'fdsfsdf'));
                          // printCapturedWidget(pngBytes!, 'order.refNo!');
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
                                await printCapturedWidget(pngBytes!, order.refNo!);
                                // final qrCode = await controller.captureFromWidget(buildBill());
                                // printCapturedWidget(qrCode);
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
                                  description: '${e}',
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
        width: orientation == Orientation.portrait ? size.width * 0.75 : size.width * 1,
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
              padding: EdgeInsets.all(8.0),
              child: RepaintBoundary(
                key: globalKey,
                child: Container(
                  width: orientation == Orientation.portrait ? size.width * 0.61 : size.width * 1,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 7,
                              child: Text(
                                'สินค้า',
                                style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
                              )),
                          Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'ราคา',
                                    style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
                                  )
                                ],
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'หน่วย xกิโล/หน่วย xราคา/กิโล',
                            style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
                          )
                        ],
                      ),
                      Column(
                        children: List.generate(
                            groupProduct.length,
                            (index) => Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        // ${sumQty(groupProduct[index].value).toInt()} x ${int.parse(sumQtyPack(groupProduct[index].value).round().toString())}
                                        Text(
                                          groupProduct[index].key,
                                          style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
                                        ),
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
                                            style: TextStyle(fontSize: orientation == Orientation.portrait ? 9 : 18),
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
                                              style: TextStyle(fontSize: orientation == Orientation.portrait ? 13 : 18),
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
                                                style:
                                                    TextStyle(fontSize: orientation == Orientation.portrait ? 13 : 18),
                                              ),
                                        // : Text(
                                        //     'รวม ${currencyFormat.format(sumPrice(groupProduct[index].value))}'),
                                        //Text('${sumPrice(groupProduct[index].value)}'),
                                      ],
                                    ),
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
                                style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
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
                                style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
                              )),
                          Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  enable == false
                                      ? Text(
                                          '0',
                                          style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
                                        )
                                      : Text(
                                          sum(product2).toStringAsFixed(2),
                                          // : Text(
                                          //     '${currencyFormat.format(sum(product2))}',
                                          style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
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
                                'ยอดค้าง',
                                style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
                              )),
                          Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
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
                                style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
                              )),
                          Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
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
                                'รวมค้าง',
                                style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
                              )),
                          Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  enable == false
                                      ? Text(
                                          '0',
                                          style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
                                        )
                                      : Text(
                                          sum(product2).toStringAsFixed(2),
                                          style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
                                        )
                                  // : Text(
                                  //     '${currencyFormat.format(sum(product2))}',
                                  //     style: TextStyle(fontSize: 16),
                                  //   )
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
                                style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
                              )),
                          Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(fontSize: orientation == Orientation.portrait ? 14 : 18),
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
}
