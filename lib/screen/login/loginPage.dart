import 'package:flutter/material.dart';
import 'package:poshuasengheng/constants/constants.dart';
import 'package:poshuasengheng/screen/login/services/loginApi.dart';
import 'package:poshuasengheng/screen/login/services/loginController.dart';
import 'package:poshuasengheng/screen/login/widgets/appTextForm.dart';
import 'package:poshuasengheng/screen/product/customerPage.dart';
import 'package:poshuasengheng/screen/product/productPage.dart';
import 'package:poshuasengheng/selectedCustomer.dart';
import 'package:poshuasengheng/widgets/LoadingDialog.dart';
import 'package:poshuasengheng/widgets/materialDialog.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      username.text = 'user@S0001';
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(body: Consumer<LoginController>(builder: (context, controller, child) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.08,
              ),
              Center(
                child: Container(
                    width: size.width * 0.65,
                    height: size.height * 0.25,
                    child: Image.asset(
                      'assets/images/Screenshot.png',
                      fit: BoxFit.fitWidth,
                    )),
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              Form(
                  key: loginFormKey,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'ชื่อผู้ใช้',
                        //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                        //   child: SizedBox(
                        //     width: size.width,
                        //     child: AppTextForm(
                        //       controller: username,
                        //       hintText: 'กรอกชื่อผู้ใช้',
                        //       validator: (val) {
                        //         if (val == null || val.isEmpty) {
                        //           return 'กรุณากรอกชื่อผู้ใช้';
                        //         }
                        //         // else if (RegExp(r'\s').hasMatch(val)) {
                        //         //   return 'รูปแบบไม่ถูกต้อง';
                        //         // }
                        //         return null;
                        //       },
                        //     ),
                        //   ),
                        // ),
                        Text(
                          'รหัสผ่าน',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                          child: AppTextForm(
                              controller: password,
                              hintText: 'รหัสผ่าน',
                              isPassword: true,
                              validator: (val) {
                                final regExp = RegExp(
                                  r'^(?=.*\d)(?=.*[a-zA-Z]).{0,}$',
                                );
                                if (val == null || val.isEmpty) {
                                  return 'กรุณากรอกพาสเวิร์ด';
                                }
                                // if (val.length < 2 || val.length > 20) {
                                //   return 'พาสเวิร์ต้องมีความยาว 8 อักษรขึ้นไป';
                                // }
                                // if (!regExp.hasMatch(val)) {
                                //   return 'รูปแบบพาสเวิร์ไม่ถูกต้อง';
                                // }
                                return null;
                              }),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: GestureDetector(
                            onTap: () async {
                              //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CustomerPage()), (route) => false);
                              if (loginFormKey.currentState!.validate()) {
                                try {
                                  LoadingDialog.open(context);
                                  await controller.signIn(username: username.text, password: password.text);
                                  if (!mounted) return;
                                  LoadingDialog.close(context);
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) => SelectedCustomer()), (route) => false);
                                } on Exception catch (e) {
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
                              }
                            },
                            child: Container(
                              height: size.height * 0.08,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kPrimaryColor),
                              child: Center(
                                child: Text(
                                  'เข้าสู่ระบบ',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      );
    })));
  }
}
