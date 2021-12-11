import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:whear/controller/weather_controller.dart';

class PredictController extends GetxController {
  late List _outputs;
  File? imagePicked;
  bool _loading = false;
  WeatherController wc = Get.find<WeatherController>();

  loadModelLook() async {
    await Tflite.loadModel(
      model: "assets/model_unquant_look.tflite",
      labels: "assets/labels_look.txt",
    );
  }

  loadModelSeason() async {
    await Tflite.loadModel(
      model: "assets/model_unquant_season.tflite",
      labels: "assets/labels_season.txt",
    );
  }

  @override
  onInit() async {
    await loadModelLook();
    super.onInit();
  }

  pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    _loading = true;
    imagePicked = File(image.path);
    print(imagePicked!);
  }

  classifyImageLook(File image) async {
    await loadModelLook();
    var result;
    print(image.path);
    var output = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0,
    ).then((value) {
      print(value);
      result = (value![0]["label"]).replaceAll(new RegExp("\\d"), "");
    });
    print(result);
    return "이 룩은 " + result + "이며, " + await classifyImageSeason(image);
    // _loading = false;
    // _outputs = output!;
    // print(_outputs);
  }

  classifyImageSeason(File image) async {
    await loadModelSeason();
    var result;
    print(image.path);
    var output = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0,
    ).then((value) {
      print(value);
      result = (value![0]["index"]);
      print("testing season");
      print(result);
      if (result == 0) {
        if (wc.degre.value < 10) {
          return "현재 날씨와 어울립니다.추위 조심하세요!!";
        } else if (wc.degre.value > 20) {
          return "현재 날씨와 어울리지 않습니다. 조금 더울 수 있습니다!!";
        } else
          return "현재 날씨와 무난하게 어울립니다!!";
      } else if (result == 1) {
        if (wc.degre.value < 10)
          return "현재 날씨엔 추울 수 있습니다. 걸칠 만한 아우터를 찾아보세요!!";
        else if (wc.degre.value > 20)
          return "오늘은 날이 더우니 직사광선에 노출되지 않도록 주의하세요!!";
        else
          return "현재 날씨와 어울립니다. 본인의 패션을 사람들에게 자랑하세요!";
      } else if (result == 2) {
        if (wc.degre.value < 10)
          return "현재 날씨엔 너무 더울 수 있습니다. 조금 더 가벼운 옷차림이 좋을 것 같아요!!";
        else if (wc.degre.value > 20)
          return "현재 날씨에 알맞는 룩입니다!! 하지만 직사광선은 좋지 않으니 야외활동을 너무 길게 하지 마세요!";
        else
          return "선선한 바람에 감기에 걸리지 않도록 주의하세요!";
      }
    });

    // _loading = false;
    return output;
    print(output);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
