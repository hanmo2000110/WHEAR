import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whear/auth/auth_middleware.dart';
import 'package:whear/binding/binding.dart';
import 'package:whear/controller/predict_controller.dart';

class WherePage extends StatefulWidget {
  const WherePage({Key? key}) : super(key: key);

  @override
  _WherePageState createState() => _WherePageState();
}

class _WherePageState extends State<WherePage> {
  PredictController pre = Get.put(PredictController());
  bool isTodayEx = true;
  bool isThisWeekEx = false;
  bool isEtcEx = false;
  var result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        title: const Text(
          'WHEAR',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              width: Get.width,
              height: 220,
              color: Colors.black,
              child: pre.imagePicked == null
                  ? Image.asset(
                      "assets/icons/5.jpg",
                      fit: BoxFit.contain,
                      alignment: Alignment.topCenter,
                    )
                  : Image.file(
                      pre.imagePicked!,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                result = await pre.pickImage();
                print(result);
                setState(() {});
              },
              child: Text("WHEAR"),
            ),
            SizedBox(
              height: 20,
            ),
            pre.imagePicked != null
                ? Text("이 옷은 ${result}(이)며 현재 날씨와 어울립니다.")
                : Container(),
          ],
        ),
      ),
    );
  }
}
