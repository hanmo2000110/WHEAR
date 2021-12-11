import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whear/controller/post_controller.dart';
import 'package:whear/model/post_model.dart';
import 'package:whear/model/user_model.dart';
import '../controller/user_controller.dart';
import '/screens/setting_page.dart';

class ProfilePageUid extends StatefulWidget {
  const ProfilePageUid({Key? key}) : super(key: key);

  @override
  _ProfilePageUidState createState() => _ProfilePageUidState();
}

class _ProfilePageUidState extends State<ProfilePageUid> {
  UserModel curuser = Get.arguments;
  TextEditingController inputController = TextEditingController();
  String inputText = '';

  bool tab = true;
  bool isEdit = false;

  List<GestureDetector> _buildGridCards(BuildContext context) {
    // if (products.isEmpty) {
    //   return const <Card>[];
    // }
    PostController pc = Get.put(PostController());
    // print("testing profile page");
    // print(products.length);

    return pc.uidposts.map((post) {
      return GestureDetector(
          onTap: () {
            Get.toNamed("detail", arguments: post);
          },
          child: Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      post.image_links[0],
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        child: ClipOval(
                          child: Container(
                            padding: EdgeInsets.all(3),
                            child: Image.asset(
                              'assets/icons/${post.wheather}.jpg',
                              // height: 30,
                              // width: 30,
                            ),
                          ),
                        ),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ])));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // final uc = Get.find<UserController>();
    final pc = Get.find<PostController>();
    // AuthController ac = Get.find();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
          title: Text(
            '${curuser.name}',
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
                size: 16,
              ),
              onPressed: () {
                Get.to(const SettingPage());
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 15.0, 50.0, 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 35.0,
                    backgroundColor: Colors.lightBlueAccent,
                    backgroundImage: NetworkImage(curuser.profile_image_url!),
                  ),
                  Column(
                    children: [
                      Text(
                        '${Get.find<PostController>().uidposts.length}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        '게시물',
                        style: TextStyle(letterSpacing: 1.0),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${curuser.follower}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        '팔로워',
                        style: TextStyle(letterSpacing: 1.0),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${curuser.following}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        '팔로잉',
                        style: TextStyle(letterSpacing: 1.0),
                      ),
                    ],
                  ),
                  //   ],
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              height: 1,
            ),
            GridView.count(
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              crossAxisCount: 3,
              padding: const EdgeInsets.all(16.0),
              childAspectRatio: 9.0 / 9.0,
              children: _buildGridCards(context),
            ),
          ],
        ),
      ),
    );
  }
}
