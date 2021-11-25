import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:whear/controller/weather_controller.dart';
import 'package:whear/auth/auth_middleware.dart';
import 'package:whear/binding/binding.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  WeatherController wc = Get.put(WeatherController());

  Future<void> _onRefresh() async {
    await wc.getWeather();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    WeatherController wc = Get.put(WeatherController());
    return Scaffold(
      appBar: AppBar(
        title: Text('WHEAR'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        key: refreshKey,
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Material(
                elevation: 20,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  // padding: EdgeInsets.all(2),
                  width: Get.width - 80,
                  height: 160,
                  // color: Colors.lightBlue[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: 20,
                          top: 10,
                        ),
                        child: Text(
                          "현재 날씨",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Obx(() {
                        return Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 12,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "${wc.degre.ceil()}˚",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: Get.width / 2 - 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Text(
                                  "최고: ${wc.max.ceil()}˚ 최저: ${wc.min.ceil()}˚",
                                  style: TextStyle(
                                    fontSize: 13,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: Get.width - 120,
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          "오늘은 미세먼지 농도가 나쁨인 날이에요 ! 마스크를 꼭 착용해주세요 :>",
                          style: TextStyle(
                            fontSize: 14,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
