import 'package:flutter/material.dart';
import 'package:poshuasengheng/constants/constants.dart';
import 'package:poshuasengheng/models/customer.dart';
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
  final TextEditingController licensePlate = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController tel = TextEditingController();
  final TextEditingController searchlicensePage = TextEditingController();
  Customer customer = Customer('', '', '', null);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('กรอกข้อมูลลูกค้า'),
        actions: [
          IconButton(
              onPressed: () async {
                context.read<LoginController>().clearToken().then((value) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
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
                AppTextTowFormField(
                  sufIcon: Icons.search,
                  controller: searchlicensePage,
                  labelText: '',
                  maxLines: 1,
                  sufPress: () async {
                    try {
                      LoadingDialog.open(context);
                      final _search = await ProductApi.getLicensePage(licensePage: searchlicensePage.text);
                      LoadingDialog.close(context);
                      if (_search.isNotEmpty) {
                        setState(() {
                          licensePlate.text = _search[0].licensePage ?? '';
                          name.text = _search[0].name ?? '';
                          tel.text = _search[0].tel ?? '';
                          customer.licensePage = _search[0].licensePage;
                          customer.name = _search[0].name;
                          customer.tel = _search[0].tel;
                          customer.id = _search[0].id;
                        });
                      } else {
                        if (!mounted) return;
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialogYes(
                              title: 'แจ้งเตือน',
                              description: 'ไม่พบเลขทะเบียนนี้',
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
                  },
                ),
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
                        if (val == null || val.isEmpty) {
                          return 'กรุณากรอก';
                        }
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
                SizedBox(
                  height: size.height * 0.08,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: GestureDetector(
                    onTap: () async {
                      if (customerFormKey.currentState!.validate()) {
                        setState(() {
                          customer.licensePage = licensePlate.text;
                          customer.name = name.text;
                          customer.tel = tel.text;
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
                          'บันทึก',
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
