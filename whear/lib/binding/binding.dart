import 'package:get/get.dart';
import 'package:whear/controller/auth_controller.dart';
import 'package:whear/controller/post_controller.dart';
import 'package:whear/controller/user_controller.dart';
import 'package:whear/controller/weather_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<PostController>(PostController(), permanent: true);
    Get.put<WeatherController>(WeatherController(), permanent: true);
  }
}
