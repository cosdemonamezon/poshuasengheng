import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
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

  Future<void> print(Customer customer, Uint8List pngBytes, String refNo) async {
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
    await SunmiPrinter.printText(
      'refNo: $refNo',
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

  static Future printPOS(
    NetworkPrinter printer,
    Uint8List customer,
    Uint8List bill,
  ) async {
    // const title = 'Orders';
    // final title = utf8.encode("รายการจัดส่งสินค้า");
    // const store = 'LaoXiangHeng';
    // const tel = 'Tel. 02-225-2387\nTel. 02-225-1587';
    // final customername = 'name: ${customer.name}';
    // final customerlicensePage = 'licensecar: ${customer.licensePage}';
    // final _refNo = 'refNo: $refNo';
    // final date = 'Date: ${DateTime.now().formatTo('dd LLL y HH:mm')}';
    // final imgSrc = Image.asset('assets/images/logo44.png');
    final ByteData data = await rootBundle.load('assets/images/logo44.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final Image? image = decodeImage(bytes);
    final Uint8List bytes2 = bill.buffer.asUint8List();
    final Image? image2 = decodeImage(bytes2);
    final Uint8List bytes3 = customer.buffer.asUint8List();
    final Image? image3 = decodeImage(bytes3);

// Using `ESC *`

    printer.image(image!);
    printer.image(image3!, align: PosAlign.left);
    // printer.text(title, styles: PosStyles(align: PosAlign.center));
    // printer.text(store);
    // printer.text(tel);
    // printer.hr();
    // printer.text(customername);
    // printer.text(customerlicensePage);
    // // printer.text(date);
    // printer.text(_refNo);
    // printer.hr();
    printer.image(image2!);
    // printer.text('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    // printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ', styles: PosStyles(codeTable: 'CP1252'));
    // printer.text('Special 2: blåbærgrød', styles: PosStyles(codeTable: 'CP1252'));

    // printer.text('Bold text', styles: PosStyles(bold: true));
    // printer.text('Reverse text', styles: PosStyles(reverse: true));
    // printer.text('Underlined text', styles: PosStyles(underline: true), linesAfter: 1);
    // printer.text('Align left', styles: PosStyles(align: PosAlign.left));
    // printer.text('Align center', styles: PosStyles(align: PosAlign.center));
    // printer.text('Align right', styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    // printer.text('Text size 200%',
    //     styles: PosStyles(
    //       height: PosTextSize.size2,
    //       width: PosTextSize.size2,
    //     ));
    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // printer.barcode(Barcode.upcA(barData));
    printer.feed(2);
    printer.cut();
    printer.disconnect();
  }
}
