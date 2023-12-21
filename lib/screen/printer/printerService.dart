import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:poshuasengheng/extension/dateExtension.dart';
import 'package:poshuasengheng/models/customer.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class PrinterService {
  const PrinterService();

  Future<Uint8List> _getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }

  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer.asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  Future<void> print(Customer customer, Uint8List pngBytes) async {
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    //const utf8Encoder = Utf8Encoder();
    //await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    Uint8List byte = await _getImageFromAsset('assets/images/logo44.png');

    //await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printImage(byte);
    await SunmiPrinter.lineWrap(1);
    //await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    //await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.exitTransactionPrint(true);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.setCustomFontSize(25);
    await SunmiPrinter.printText(
      'รายการจัดส่งสินค้า',
    );
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.setCustomFontSize(24);
    await SunmiPrinter.printText(
      'ร้านค้า เล้าเซี่ยงเฮง',
    );
    // await SunmiPrinter.setCustomFontSize(22);
    // await SunmiPrinter.printText(
    //   'ที่อยู่ 255 – 257 อาคารเล้าเซี่ยงเฮง 2 ชั้น 2 ถนนเยาวราช แขวง/เขตสัมพันธวงศ์ กรุงเทพฯ 10100 โทร  02 112 2222',
    // );
    await SunmiPrinter.setCustomFontSize(22);
    await SunmiPrinter.printText(
      'โทร 02-225-2387\nโทร 02-225-1587',
    );
    await SunmiPrinter.line();
    // await SunmiPrinter.setCustomFontSize(25);
    // await SunmiPrinter.printText(
    //   'ชื่อลูกค้า: ${customer.name}',
    // );
    await SunmiPrinter.setCustomFontSize(24);
    await SunmiPrinter.printText(
      'ชื่อ: ${customer.name}',
    );
    await SunmiPrinter.setCustomFontSize(24);
    await SunmiPrinter.printText(
      'ทะเบียนรถ: ${customer.licensePage}',
    );
    await SunmiPrinter.setCustomFontSize(24);
    await SunmiPrinter.printText(
      'วันที่: ${DateTime.now().formatTo('dd LLL y HH:mm น.')}',
    );
    // await SunmiPrinter.setCustomFontSize(24);
    // await SunmiPrinter.printText(
    //   'เบอร์โทร: ${customer.tel}',
    // );

    await SunmiPrinter.line();
    await SunmiPrinter.printImage(pngBytes);
    //await SunmiPrinter.setCustomFontSize(20);
    // for (var i = 0; i < finalListProducts.length; i++) {
    //   await SunmiPrinter.setCustomFontSize(20);
    //   await SunmiPrinter.printImage(pngBytes);
    //   // await SunmiPrinter.printRow(cols: [
    //   //     ColumnMaker(
    //   //       text: '${finalListProducts[i]['name']}(x${finalListProducts[i]['name']})',
    //   //       width: 27,
    //   //       align: SunmiPrintAlign.LEFT,
    //   //     ),
    //   //     ColumnMaker(
    //   //       text: '${finalListProducts[i]['qty']} ${finalListProducts[i]['unit']}',
    //   //       //text: '${printer.confirmOrder!.orders![i].price_per_unit}',
    //   //       width: 7,
    //   //       align: SunmiPrintAlign.RIGHT,
    //   //     ),
    //   //   ]);
    //   // await SunmiPrinter.printText(
    //   //   '${finalListProducts[i]['name']}            ${finalListProducts[i]['qty']} ${finalListProducts[i]['unit']}',
    //   // );
    // }

    await SunmiPrinter.line();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText('Thank you');

    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.exitTransactionPrint(true);
  }
}
