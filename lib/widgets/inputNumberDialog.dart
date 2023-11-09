import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:poshuasengheng/constants/constants.dart';
import 'package:poshuasengheng/models/product.dart';

class InputNumberDialog extends StatefulWidget {
  InputNumberDialog({Key? key, required this.product}) : super(key: key);
  Product product;

  @override
  State<InputNumberDialog> createState() => _InputNumberDialogState();
}

class _InputNumberDialogState extends State<InputNumberDialog> {
  final TextEditingController? numberPick = TextEditingController();
  int qty = 1;
  int qtyPack = 1;
  int id = 1;
  int selectValue = 1;
  final TextEditingController _myNumber = TextEditingController();
  @override
  void initState() {
    super.initState();
    widget.product.unit = 'กิโล';
    if (widget.product.unit == 'กิโล') {
      widget.product.unitId = 2;
    }
    qty = widget.product.qty!;
    qtyPack = widget.product.qtyPack!;
  }

  @override
  void dispose() {
    super.dispose();
    numberPick!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text('สินค้า: ${widget.product.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ระบุจำนวนสินค้า',
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              // TextButton(
              //   style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.grey, width: 2)))),
              //   onPressed: () {
              //     setState(() {
              //       if (qty > 1) {
              //         qty = qty - 1;
              //         widget.product.qty = qty;
              //       } else {}
              //     });
              //   },
              //   child: Icon(
              //     Icons.remove,
              //     color: Colors.red,
              //   ),
              // ),
              GestureDetector(
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
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                height: size.height * 0.05,
                                child: Center(
                                    child: TextField(
                                  controller: _myNumber,
                                  textAlign: TextAlign.center,
                                  showCursor: false,
                                  style: TextStyle(fontSize: 30),
                                  // Disable the default soft keybaord
                                  keyboardType: TextInputType.none,
                                )),
                              ),
                            ),
                            NumPad(
                              buttonSize: 70,
                              buttonColor: Colors.black,
                              iconColor: Colors.deepOrange,
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
                  if (addQty != null) {
                    setState(() {
                      String a = '';
                      List<String> b = [];
                      List<String> k = [];
                      String originalString = "Hello, World!";

                      for (var character in addQty.runes) {
                        String singleCharacter = String.fromCharCode(character);
                        //print(singleCharacter);
                        if (singleCharacter == 'x') {
                          k.add(a);
                          a = '';
                        } else if (singleCharacter == '/') {
                          b.add(a);
                          a = '';
                        } else {
                          a += singleCharacter;
                        }
                      }
                      // inspect(k);
                      // inspect(b);
                      // inspect(b);
                    });
                  }
                },
                child: Container(
                  width: size.width * 0.285,
                  height: size.height * 0.06,
                  child: Center(
                      child: Text(
                    '${qty}',
                    style: TextStyle(fontSize: 18),
                  )),
                ),
              ),
              // SizedBox(
              //   width: size.width * 0.285,
              //   height: size.height * 0.06,
              //   child: Container(
              //     decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              //     child: TextFormField(
              //       keyboardType: TextInputType.number,
              //       controller: numberPick,
              //       decoration: InputDecoration(
              //         border: OutlineInputBorder(
              //           borderSide: BorderSide.none,
              //           borderRadius: BorderRadius.all(
              //             Radius.circular(10),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // TextButton(
              //   style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.grey, width: 2)))),
              //   onPressed: () {
              //     setState(() {
              //       qty = qty + 1;
              //       widget.product.qty = qty;
              //     });
              //     print(qty);
              //   },
              //   child: Icon(Icons.add),
              // ),
            ],
          ),
          // Text(
          //   'เลือกถุง',
          //   style: TextStyle(fontSize: 16),
          // ),
          // Row(
          //   children: [
          //     TextButton(
          //       style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.grey, width: 2)))),
          //       onPressed: () {
          //         setState(() {
          //           if (qtyPack > 1) {
          //             qtyPack = qtyPack - 1;
          //             widget.product.qtyPack = qtyPack;
          //           } else {}
          //         });
          //       },
          //       child: Icon(
          //         Icons.remove,
          //         color: Colors.red,
          //       ),
          //     ),
          //     Container(
          //       width: size.width * 0.285,
          //       height: size.height * 0.06,
          //       child: Center(
          //           child: Text(
          //         '${qtyPack}',
          //         style: TextStyle(fontSize: 18),
          //       )),
          //     ),
          //     TextButton(
          //       style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.grey, width: 2)))),
          //       onPressed: () {
          //         setState(() {
          //           qtyPack = qtyPack + 1;
          //           widget.product.qtyPack = qtyPack;
          //         });
          //         print(qtyPack);
          //       },
          //       child: Icon(Icons.add),
          //     ),
          //   ],
          // ),
          // Row(
          //   children: [
          //     Radio(
          //       value: 1,
          //       groupValue: id,
          //       onChanged: (value) {
          //         setState(() {
          //           selectValue = value!;
          //           id = value;
          //           widget.product.unit = 'กิโล';
          //           widget.product.unitId = 2;
          //         });
          //         print(selectValue);
          //       },
          //     ),
          //     Text(
          //       'กิโล',
          //       style: TextStyle(fontSize: 17.0),
          //     ),
          //     Radio(
          //       value: 2,
          //       groupValue: id,
          //       onChanged: (value) {
          //         setState(() {
          //           selectValue = value!;
          //           id = value;
          //           widget.product.unit = 'ถุง';
          //           widget.product.unitId = 1;
          //         });
          //         print(selectValue);
          //       },
          //     ),
          //     Text(
          //       'ถุง',
          //       style: TextStyle(fontSize: 17.0),
          //     ),
          //   ],
          // ),
        ],
      ),
      actions: [
        TextButton(
          style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.grey, width: 2)))),
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Text(
            'ยกเลิก',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.grey, width: 2)))),
          onPressed: () {
            setState(() {
              widget.product.select = true;
            });
            Navigator.pop(context, widget.product);
          },
          child: Text('ตกลง'),
        ),
      ],
    );
  }
}

class NumPad extends StatelessWidget {
  final double buttonSize;
  final Color buttonColor;
  final Color iconColor;
  final TextEditingController controller;
  final Function delete;
  final Function onSubmit;

  const NumPad({
    Key? key,
    this.buttonSize = 70,
    this.buttonColor = Colors.indigo,
    this.iconColor = Colors.amber,
    required this.delete,
    required this.onSubmit,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: [
          //const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // implement the number keys (from 0 to 9) with the NumberButton widget
            // the NumberButton widget is defined in the bottom of this file
            children: [
              NumberButton(
                number: '1',
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: '2',
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: '3',
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: '4',
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: '5',
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: '6',
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: '7',
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: '8',
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: '9',
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // this button is used to delete the last number
              NumberButton(
                number: '0',
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: '/',
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 'x',
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => delete(),
                icon: Icon(
                  Icons.delete,
                  color: iconColor,
                ),
                iconSize: buttonSize,
              ),
              GestureDetector(
                onTap: () => onSubmit(),
                child: Container(
                  decoration: BoxDecoration(color: kSecondaryColor, borderRadius: BorderRadius.all(Radius.circular(20))),
                  height: 60,
                  width: 150,
                  child: Center(
                    child: Text('ยืนยัน',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(color: kSecondaryColor, borderRadius: BorderRadius.all(Radius.circular(20))),
              //   height: size.height * 0.05,
              //   width: size.height * 0.08,
              //   child: Center(
              //       child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         'ยืนยันรายการ',
              //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              //       ),
                    
              //     ],
              //   )),
              // ),
              // IconButton(
              //   onPressed: () => onSubmit(),
              //   icon: Icon(
              //     Icons.confirmation_number,
              //     color: iconColor,
              //   ),
              //   iconSize: buttonSize,
              // ),
              //CircleAvatar(radius: 32,),
            ],
          ),
        ],
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final String number;
  final double size;
  final Color color;
  final TextEditingController controller;

  const NumberButton({
    Key? key,
    required this.number,
    required this.size,
    required this.color,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
        onPressed: () {
          controller.text += number.toString();
        },
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }
}
