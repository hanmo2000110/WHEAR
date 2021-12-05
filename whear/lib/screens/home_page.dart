import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:whear/controller/predict_controller.dart';
import 'package:whear/controller/user_controller.dart';

import 'package:whear/controller/weather_controller.dart';
import 'package:whear/auth/auth_middleware.dart';
import 'package:whear/binding/binding.dart';
import 'package:whear/model/user_model.dart';

import '/model/post_model.dart';
import '/controller/post_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  WeatherController wc = Get.put(WeatherController());
  PredictController predict = Get.put(PredictController());

  Future<void> _onRefresh() async {
    await wc.getWeather();
    setState(() {});
  }

  List<Card> _buildListViews(BuildContext context) {
    // List<PostModel> products = [];
    PostController pc = Get.put(PostController());
    List<PostModel> products = pc.searchposts;
    UserController uc = Get.put(UserController());
    UserModel usermodel = uc.user;
    print("length test");
    print(products.length);
    return products.map((product) {
      return Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              width: Get.width - 40,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.lightBlueAccent,
                          backgroundImage: NetworkImage(
                              FirebaseAuth.instance.currentUser!.photoURL!),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Text('${usermodel.name}'),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                          child: Text(
                            '공항패션',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Container(
                          color: Colors.white,
                          child: Image.asset(
                            'assets/icons/sunny.jpg',
                            height: 30,
                            width: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: Get.width,
              height: 220,
              color: Colors.black,
              child: Image.network(
                "${product.image_links[0]}",
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.wb_cloudy_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.weekend_outlined),
                        onPressed: () {},
                      )
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.work_outline_outlined),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: Get.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${product.content}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '좋아요 17개',
                      style: TextStyle(fontSize: 10),
                    ),
                    InkWell(
                      child: Text(
                        '댓글 n개 모두보기',
                        style: TextStyle(fontSize: 10),
                      ),
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  PredictController pre = Get.put(PredictController());
  @override
  Widget build(BuildContext context) {
    WeatherController wc = Get.put(WeatherController());
    // PostController pc = Get.put(PostController());
    // pc.getPosts();
    // setState(() {});

    return Scaffold(
      appBar: AppBar(
        title: Text('WHEAR'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: InkWell(
              child: Icon(Icons.add),
              onTap: () async {
                await pre.pickImage();
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: _onRefresh,
          key: refreshKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Material(
                    elevation: 5,
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
                GridView.count(
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  crossAxisCount: 1,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  children: _buildListViews(context),
                )
              ],
            ),
          )),
    );
  }
}
