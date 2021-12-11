import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whear/controller/post_controller.dart';
import 'package:whear/model/user_model.dart';

import '/model/post_model.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // static PostModel detailpost = Get.arguments;
  // List<dynamic> imgList = detailpost.image_links;
  PostController pc = Get.put(PostController());
  @override
  Widget build(BuildContext context) {
    PostModel detailpost = Get.arguments;
    List<dynamic> imgList = detailpost.image_links;
    int likes;
    bool iLiked, iSaved;
    likes = detailpost.likes!.value;
    iLiked = !detailpost.iLiked!;
    iSaved = !detailpost.iSaved!;
    print(iLiked);
    return Scaffold(
        backgroundColor: Colors.white,
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
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "WHEAR",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: SingleChildScrollView(
            child: Card(
          elevation: 0,
          borderOnForeground: false,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  pc.cleanUidPost();
                  await pc.getPostsUid(detailpost.creator);
                  var result = await FirebaseFirestore.instance
                      .collection('user')
                      .doc(detailpost.creator)
                      .get();
                  UserModel curuser = UserModel(
                    email: result.data()!['email'],
                    uid: detailpost.creator,
                    name: result.data()!['name'],
                    profile_image_url: result.data()!['profile_image_url'],
                    status_message: result.data()!['status_message'],
                    follower: result.data()!['follower'],
                    following: result.data()!['following'],
                  );

                  await Get.toNamed("profileuid", arguments: curuser)!
                      .then((value) => setState(() {}));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
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
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text('${detailpost.creatorName}'),
                        ],
                      ),
                      Row(children: [
                        Container(
                          child: Image.asset(
                            'assets/icons/${detailpost.wheather}.jpg',
                            height: 30,
                            width: 30,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
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
                      ]),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Get.toNamed("detail", arguments: detailpost)!
                      .then((value) => setState(() {}));
                },
                child: SizedBox(
                  height: Get.height / 2.5,
                  width: Get.width,
                  child: detailpost.image_links.length != 1
                      ? CarouselSlider(
                          options: CarouselOptions(
                            enableInfiniteScroll: false,
                            height: 400.0,
                            aspectRatio: 10 / 10,
                            viewportFraction: 1.0,
                          ),
                          items: detailpost.image_links.map((img) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  img,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              detailpost.image_links[0],
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    splashColor: Colors.transparent,
                    icon: iLiked
                        ? Icon(Icons.wb_cloudy_outlined,
                            color: Colors.grey.shade600)
                        : Icon(
                            Icons.wb_cloudy,
                            color: Colors.lightBlueAccent.shade100,
                          ),
                    onPressed: () async {
                      await pc.like(detailpost.post_id);
                      iLiked = await pc.iLiked(detailpost.post_id);
                      likes = await pc.countLike(detailpost.post_id);
                      detailpost.iLiked = !iLiked;
                      detailpost.likes!.value = likes;

                      // print(iLiked);
                      // print(likes);

                      setState(() {});
                    },
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    icon: iSaved
                        ? Icon(Icons.work_outline_outlined,
                            color: Colors.grey.shade600)
                        : Icon(
                            Icons.work,
                            color: Colors.brown.shade400,
                          ),
                    onPressed: () async {
                      await pc.savePost(detailpost.post_id);
                      iSaved = await pc.iSaved(detailpost.post_id);
                      detailpost.iSaved = !iSaved;

                      setState(() {});
                    },
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
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
                        '좋아요 $likes개',
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
