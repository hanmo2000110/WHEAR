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
  var str1, str2;
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

                await pre.pickImage();
                str1 = await pre.classifyImageLook(pre.imagePicked!);
                // str2 = pre.classifyImageSeason(pre.imagePicked!);

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
                ? Container(
                    width: Get.width - 100,
                    child: Text(str1),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
