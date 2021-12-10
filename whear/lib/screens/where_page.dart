import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.white,
        title: const Text(
          'WHEAR',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                result = await pre.pickImage();
                print(result);
                setState(() {});
              },
              child: SizedBox(
                width: Get.width,
                height: Get.width,
                child: pre.imagePicked == null
                    ? const Center(
                        child: Text("사진을 선택하려면 터치하세요!"),
                      )
                    : Image.file(
                        pre.imagePicked!,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
              ),
            ),
            const SizedBox(
              height: 40,
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
