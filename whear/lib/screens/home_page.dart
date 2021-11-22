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
  WeatherController wc = Get.put(WeatherController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WHEAR'),
      ),
      body: Column(
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
                  children: [
                    Text("${WeatherController().degre}"),
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
    );
  }
}
