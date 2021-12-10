import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class PredictController extends GetxController {
  late List _outputs;
  File? imagePicked;
  bool _loading = false;

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  onInit() async {
    await loadModel();
    super.onInit();
  }

  pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    _loading = true;
    imagePicked = File(image.path);
    print(imagePicked!);
    return classifyImage(imagePicked!);
  }

  classifyImage(File image) async {
    var result;
    print(image.path);
    var output = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0,
    ).then((value) {
      print(value);
      result = (value![0]["label"]).replaceAll(new RegExp("\\d"), "") +
          " 또는" +
          (value[1]["label"]).replaceAll(new RegExp("\\d"), "");
    });
    print(result);
    return result;
    // _loading = false;
    // _outputs = output!;
    // print(_outputs);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
