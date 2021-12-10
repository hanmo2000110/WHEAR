import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'detail_page.dart';

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

  List<GestureDetector> _buildListViews(BuildContext context) {
    // List<PostModel> products = [];
    PostController pc = Get.put(PostController());
    List<PostModel> posts = pc.searchposts;
    // UserController uc = Get.put(UserController());
    // UserModel usermodel = uc.user;

    return posts.map((post) {
      // String creator = post.creator;

      return GestureDetector(
        onTap: () {
          Get.toNamed("detail", arguments: post);
        },
        child: Card(
          elevation: 0,
          borderOnForeground: false,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              SizedBox(
                width: Get.width - 40,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.lightBlueAccent,
                          backgroundImage:
                              NetworkImage(post.creatorProfilePhotoURL!),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Text('${post.creatorName}'),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                          child: Text(
                            post.lookType,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Container(
                          color: Colors.white,
                          child: Image.asset(
                            'assets/icons/${post.wheather}.jpg',
                            height: 30,
                            width: 30,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: Get.width,
                height: Get.width,
                color: Colors.black,
                child: Image.network(
                  post.image_links[0],
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.wb_cloudy_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.weekend_outlined),
                        onPressed: () {},
                      )
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.work_outline_outlined),
                    onPressed: () {},
                  )
                ],
              ),
              SizedBox(
                width: Get.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        '${post.content}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(
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
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              )
            ],
          ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'WHEAR',
          style: TextStyle(color: Colors.black),
        ),
        shadowColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: InkWell(
              child: const Icon(Icons.add),
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
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Material(
                    elevation: 5,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      // padding: EdgeInsets.all(2),
                      width: Get.width - 80,
                      height: 160,
                      // color: Colors.lightBlue[100],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 10,
                            ),
                            child: const Text(
                              "현재 날씨",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Obx(() {
                            return Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                                top: 12,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "${wc.degre.ceil()}˚",
                                    style: const TextStyle(
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
                                      style: const TextStyle(
                                        fontSize: 13,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: Get.width - 120,
                            padding: const EdgeInsets.only(
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [..._buildListViews(context)],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
