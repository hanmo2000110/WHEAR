import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class PredictController extends GetxController {
  late List _outputs;
  late File _image;
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
    _image = File(image.path);

    classifyImage(_image);
  }

  classifyImage(File image) async {
    print(image.path);
    var output = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 127.5,
      imageStd: 127.5,
    ).then((value) {
      print(value![0]["label"]);
    });

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
