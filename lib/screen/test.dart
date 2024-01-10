// import 'dart:developer';

// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:image/image.dart';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';

// Future<void> main2() async {
//   final profile = await CapabilityProfile.load();
//   final generator = Generator(PaperSize.mm80, profile);
//   List<int> bytes = [];

//   generator.text('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
//   generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ', styles: PosStyles(codeTable: 'CP1252'));
//   generator.text('Special 2: blåbærgrød', styles: PosStyles(codeTable: 'CP1252'));

//   generator.text('Bold text', styles: PosStyles(bold: true));
//   generator.text('Reverse text', styles: PosStyles(reverse: true));
//   generator.text('Underlined text', styles: PosStyles(underline: true), linesAfter: 1);
//   generator.text('Align left', styles: PosStyles(align: PosAlign.left));
//   generator.text('Align center', styles: PosStyles(align: PosAlign.center));
//   generator.text('Align right', styles: PosStyles(align: PosAlign.right), linesAfter: 1);

//   generator.row([
//     PosColumn(
//       text: 'col3',
//       width: 3,
//       styles: PosStyles(align: PosAlign.center, underline: true),
//     ),
//     PosColumn(
//       text: 'col6',
//       width: 6,
//       styles: PosStyles(align: PosAlign.center, underline: true),
//     ),
//     PosColumn(
//       text: 'col3',
//       width: 3,
//       styles: PosStyles(align: PosAlign.center, underline: true),
//     ),
//   ]);

//   generator.text('Text size 200%',
//       styles: PosStyles(
//         height: PosTextSize.size2,
//         width: PosTextSize.size2,
//       ));

//   // Print image:
//   final ByteData data = await rootBundle.load('assets/images/Screenshot.png');
//   final Uint8List imgBytes = data.buffer.asUint8List();
//   final Image image = decodeImage(imgBytes)!;
//   generator.image(image);
//   // Print image using an alternative (obsolette) command
//   // generator.imageRaster(image);

//   // Print barcode
//   final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
//   generator.barcode(Barcode.upcA(barData));

//   // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
//   // ticket.text(
//   //   'hello ! 中文字 # world @ éphémère &',
//   //   styles: PosStyles(codeTable: PosCodeTable.westEur),
//   //   containsChinese: true,
//   // );

//   generator.feed(2);
//   generator.cut();
// }

// Future<void> testPrint22() async {
//   const PaperSize paper = PaperSize.mm80;
//   // final profiles = await CapabilityProfile.getAvailableProfiles();
//   final profile = await CapabilityProfile.load(name: 'XP-N160I');
//   final printer = NetworkPrinter(paper, profile);
//   // inspect(profiles);

//   final PosPrintResult res = await printer.connect('192.168.1.200', port: 9100);

//   if (res == PosPrintResult.success) {
//     // DEMO RECEIPT
//     // await printDemoReceipt(printer, refNo);
//     // TEST PRINT
//     // await testTicket(refNo: refNo);
//     await main2();
//   }

//   // final snackBar = SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
//   // Scaffold.of(ctx).showSnackBar(snackBar);
// }
