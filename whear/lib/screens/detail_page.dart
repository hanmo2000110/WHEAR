import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/model/post_model.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // static PostModel detailpost = Get.arguments;
  // List<dynamic> imgList = detailpost.image_links;

  @override
  Widget build(BuildContext context) {
    PostModel detailpost = Get.arguments;
    List<dynamic> imgList = detailpost.image_links;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
              size: 16,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            "Detail",
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
        body: SingleChildScrollView(
          child: Card(
            elevation: 0,
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
                              backgroundImage: NetworkImage(
                                detailpost.creatorProfilePhotoURL!,
                              )),
                          const SizedBox(
                            width: 25,
                          ),
                          Text('${detailpost.creatorName}'),
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
                              detailpost.lookType,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Container(
                            color: Colors.white,
                            // child: Text('${detailpost.wheather}'),
                            child: Image.asset(
                              'assets/icons/${detailpost.wheather}.jpg',
                              height: 30,
                              width: 30,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height / 2.5,
                  width: Get.width,
                  child: imgList.length != 1
                      ? CarouselSlider(
                          options: CarouselOptions(height: 400.0),
                          items: imgList.map((img) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(img),
                              ),
                            );
                          }).toList(),
                        )
                      : SizedBox(
                          width: Get.width,
                          height: Get.height / 2.5,
                          child: Image.network(imgList[0]),
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
                      Text(
                        '${detailpost.content}',
                        style: const TextStyle(fontSize: 12),
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
        ));
  }
}
