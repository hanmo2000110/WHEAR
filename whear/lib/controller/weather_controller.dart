import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:whear/model/weather_model.dart';

class WeatherController extends GetxController {
  RxDouble degre = 0.0.obs;
  RxDouble max = 0.0.obs;
  RxDouble min = 0.0.obs;
  @override
  onInit() async {
    await getWeather();
    super.onInit();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    print(await Geolocator.getCurrentPosition());
    return await Geolocator.getCurrentPosition();
  }

  final _openweatherkey = '79cfe195a41d6318d818fde2d451e4d2';

  Future<void> getWeatherData({
    @required double? lat,
    @required double? lon,
  }) async {
    var str =
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=${_openweatherkey}&units=metric';
    print(str);
    var response = await http.get(Uri.parse(str));

    if (response.statusCode == 200) {
      var data = response.body;
      var dataJson = jsonDecode(data); // string to json

      print('data = $data');
      print('${dataJson['main']['temp']}');
      degre.value = await dataJson['main']['temp'];
      max.value = await dataJson['main']['temp_max'] * 1.0;
      min.value = await dataJson['main']['temp_min'] * 1.0;
      print(degre.value);
    } else {
      print('response status code = ${response.statusCode}');
    }
    return;
  }

  Future<void> getWeather() async {
    var pos = await _determinePosition();
    var n = await getWeatherData(lon: pos.longitude, lat: pos.latitude);
  }
}
