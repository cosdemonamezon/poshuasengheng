import 'package:flutter/material.dart';
import 'package:poshuasengheng/constants/constants.dart';
import 'package:poshuasengheng/models/customer.dart';
import 'package:poshuasengheng/screen/login/widgets/appTextForm.dart';
import 'package:poshuasengheng/screen/product/productPage.dart';
import 'package:poshuasengheng/selectedCustomer.dart';
import 'package:poshuasengheng/widgets/LoadingDialog.dart';
import 'package:poshuasengheng/widgets/materialDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingprinterFirst extends StatefulWidget {
  const SettingprinterFirst({
    super.key,
  });

  @override
  State<SettingprinterFirst> createState() => _SettingprinterFirstState();
}

class _SettingprinterFirstState extends State<SettingprinterFirst> {
  final TextEditingController ipAddress = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();
    getIp();
  }

  Future getIp() async {
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString('ipAddress');
    setState(() {
      ipAddress.text = ip!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('ตั้งค่า IP เครื่องปริ้น'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                return SelectedCustomer();
              }), (route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kPrimaryColor),
                child: Center(
                  child: Text(
                    'ข้าม',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.2, horizontal: size.height * 0.15),
              child: AppTextForm(
                controller: ipAddress,
                hintText: 'IP address',
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: GestureDetector(
                onTap: () async {
                  LoadingDialog.open(context);
                  final SharedPreferences prefs = await _prefs;
                  await prefs.setString('ipAddress', ipAddress.text);
                  if (!mounted) return;
                  final ok = await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialogYes(
                        title: 'แจ้งเตือน',
                        description: 'บันทึกสำเร็จ',
                        pressYes: () {
                          Navigator.pop(context, true);
                        },
                      );
                    },
                  );
                  if (ok == true) {
                    if (!mounted) return;
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                      return SelectedCustomer();
                    }), (route) => false);
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    //   return ProductPage(
                    //     customer: widget.customer,
                    //   );
                    // }));
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.15),
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
            ),
          ],
        ),
      ),
    );
  }
}
