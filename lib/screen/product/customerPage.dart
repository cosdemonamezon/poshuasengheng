import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:poshuasengheng/constants/constants.dart';
import 'package:poshuasengheng/models/customer.dart';
import 'package:poshuasengheng/models/orderdraft.dart';
import 'package:poshuasengheng/screen/login/loginPage.dart';
import 'package:poshuasengheng/screen/login/services/loginController.dart';
import 'package:poshuasengheng/screen/login/widgets/appTextForm.dart';
import 'package:poshuasengheng/screen/product/productPage.dart';
import 'package:poshuasengheng/screen/product/services/productApi.dart';
import 'package:poshuasengheng/widgets/LoadingDialog.dart';
import 'package:poshuasengheng/widgets/materialDialog.dart';
import 'package:provider/provider.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final GlobalKey<FormState> customerFormKey = GlobalKey<FormState>();
  final TextEditingController? licensePlate = TextEditingController();
  final TextEditingController? name = TextEditingController();
  final TextEditingController? tel = TextEditingController();
  final TextEditingController searchlicensePage = TextEditingController();
  Customer customer = Customer(' - ', ' - ', ' - ', '', null);
  Customer? selectedCustomer;
  final List<Customer> listCustomer = [];
  int id = 1;
  String radioButtonItem = 'credit';

  getStation() async {
    final _getCustomer = await ProductApi.getLicensePage(licensePage: searchlicensePage.text);
    setState(() {
      listCustomer.clear();
      listCustomer.addAll(_getCustomer);
      // selectedStation = listStation[0];
    });
  }

  @override
  void initState() {
    super.initState();
    getStation();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final underlineInputBorder = UnderlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: kPrimaryColor, width: 5),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('กรอกข้อมูลลูกค้า'),
        actions: [
          IconButton(
              onPressed: () async {
                context.read<LoginController>().clearToken().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                });
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * 0.03),
          child: Form(
            key: customerFormKey,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                DropdownSearch<Customer>(
                  selectedItem: selectedCustomer,
                  items: listCustomer,
                  itemAsString: (item) => item.name!,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    fit: FlexFit.loose,
                    // dialogProps: DialogProps(
                    //   backgroundColor: Color.fromARGB(243, 158, 158, 158),
                    // ),
                    searchDelay: Duration(milliseconds: 100),
                    containerBuilder: (context, popupWidget) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kPrimaryColor, width: 3),
                      ),
                      child: popupWidget,
                    ),
                    itemBuilder: (context, item, isSelected) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name!,
                            style: TextStyle(color: Colors.black),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1.5,
                          )
                        ],
                      ),
                    ),
                    searchFieldProps: TextFieldProps(
                      cursorColor: kPrimaryColor,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'ค้นหารายชื่อ',
                        prefixIcon: Icon(Icons.search),
                        prefixIconColor: Colors.black,
                        enabledBorder: underlineInputBorder,
                        focusedBorder: underlineInputBorder,
                      ),
                    ),
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    // baseStyle: style,
                    dropdownSearchDecoration: InputDecoration(
                      hintText: 'รายชื่อ',
                      // hintStyle: style,
                      border: InputBorder.none,
                      suffixIconColor: Colors.black,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: kPrimaryColor,
                          width: 3,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: kPrimaryColor,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    selectedCustomer = value;
                    setState(() {
                      licensePlate?.text = value!.licensePage ?? ' - ';
                      name?.text = value!.name ?? ' - ';
                      tel?.text = value!.tel ?? ' - ';
                      customer.licensePage = value!.licensePage;
                      customer.name = value.name;
                      customer.tel = value.tel;
                      customer.id = value.id;
                    });
                  },
                ),
                // AppTextTowFormField(
                //   sufIcon: Icons.search,
                //   controller: searchlicensePage,
                //   labelText: '',
                //   maxLines: 1,
                //   sufPress: () async {
                //     try {
                //       LoadingDialog.open(context);
                //       final _search = await ProductApi.getLicensePage(licensePage: searchlicensePage.text);
                //       LoadingDialog.close(context);
                //       if (_search.isNotEmpty) {
                //         setState(() {
                //           licensePlate?.text = _search[0].licensePage ?? ' - ';
                //           name?.text = _search[0].name ?? ' - ';
                //           tel?.text = _search[0].tel ?? ' - ';
                //           customer.licensePage = _search[0].licensePage;
                //           customer.name = _search[0].name;
                //           customer.tel = _search[0].tel;
                //           customer.id = _search[0].id;
                //         });
                //       } else {
                //         if (!mounted) return;
                //         showDialog(
                //           context: context,
                //           barrierDismissible: false,
                //           builder: (BuildContext context) {
                //             return AlertDialogYes(
                //               title: 'แจ้งเตือน',
                //               description: 'ไม่พบเลขทะเบียนนี้',
                //               pressYes: () {
                //                 Navigator.pop(context, true);
                //               },
                //             );
                //           },
                //         );
                //       }
                //     } on Exception catch (e) {
                //       if (!mounted) return;
                //       LoadingDialog.close(context);
                //       showDialog(
                //         context: context,
                //         barrierDismissible: false,
                //         builder: (BuildContext context) {
                //           return AlertDialogYes(
                //             title: 'แจ้งเตือน',
                //             description: '${e}',
                //             pressYes: () {
                //               Navigator.pop(context, true);
                //             },
                //           );
                //         },
                //       );
                //     }
                //   },
                // ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                Row(
                  children: [
                    Text(
                      'ทะเบียนรถ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: SizedBox(
                    width: size.width,
                    child: AppTextForm(
                      controller: licensePlate,
                      hintText: '',
                      validator: (val) {
                        // if (val == null || val.isEmpty) {
                        //   return 'กรุณากรอก';
                        // }
                        // else if (RegExp(r'\s').hasMatch(val)) {
                        //   return 'รูปแบบไม่ถูกต้อง';
                        // }
                        return null;
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'ชื่อลูกค้า',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: SizedBox(
                    width: size.width,
                    child: AppTextForm(
                      controller: name,
                      hintText: '',
                      validator: (val) {
                        // if (val == null || val.isEmpty) {
                        //   return 'กรุณากรอก';
                        // }
                        // else if (RegExp(r'\s').hasMatch(val)) {
                        //   return 'รูปแบบไม่ถูกต้อง';
                        // }
                        return null;
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'เบอร์โทร',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: SizedBox(
                    width: size.width,
                    child: AppTextForm(
                      controller: tel,
                      hintText: '',
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        // if (val == null || val.isEmpty) {
                        //   return 'กรุณากรอก';
                        // } else if (RegExp(r'\s').hasMatch(val)) {
                        //   return 'รูปแบบไม่ถูกต้อง';
                        // }
                        return null;
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'จ่ายเงิน',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: id,
                          onChanged: (val) {
                            setState(() {
                              radioButtonItem = 'credit';
                              id = 1;
                            });
                          },
                        ),
                        Text(
                          'เครดิต',
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 2,
                          groupValue: id,
                          onChanged: (val) {
                            setState(() {
                              radioButtonItem = 'cash';
                              id = 2;
                            });
                          },
                        ),
                        Text(
                          'เงินสด',
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.08,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: GestureDetector(
                    onTap: () async {
                      if (customerFormKey.currentState!.validate()) {
                        setState(() {
                          customer.licensePage = licensePlate?.text ?? ' - ';
                          customer.name = name?.text ?? ' - ';
                          customer.tel = tel?.text ?? ' - ';
                          customer.payMentType = radioButtonItem;
                          inspect(customer);
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductPage(
                                      customer: customer,
                                    )));
                      }
                    },
                    child: Container(
                      height: size.height * 0.08,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kPrimaryColor),
                      child: Center(
                        child: Text(
                          'ตกลง',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
