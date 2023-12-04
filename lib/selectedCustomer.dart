import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:poshuasengheng/models/customer.dart';
import 'package:poshuasengheng/screen/product/customerPage.dart';
import 'package:poshuasengheng/screen/product/productPage.dart';

class SelectedCustomer extends StatefulWidget {
  const SelectedCustomer({super.key});

  @override
  State<SelectedCustomer> createState() => _SelectedCustomerState();
}

class _SelectedCustomerState extends State<SelectedCustomer> {
  Customer customer = Customer(' - ', ' - ', '', '', null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('เลือกประเภท'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CustomerPage();
                }));
              },
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 211, 210, 210),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_search,
                      size: 50,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'รายชื่อลูกค้า',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  customer.payMentType = 'cash';
                });
                inspect(customer);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductPage(
                              customer: customer,
                            )));
              },
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 211, 210, 210),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 50,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'เงินสด',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
