import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whear/controller/post_controller.dart';
import 'package:whear/model/post_model.dart';
import 'package:whear/model/user_model.dart';

import '../controller/auth_controller.dart';
import '../controller/user_controller.dart';
import '/screens/setting_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController inputController = TextEditingController();
  String inputText = '';

  bool tab = true;
  bool isEdit = false;

  List<GestureDetector> _buildGridCards(BuildContext context) {
    // if (products.isEmpty) {
    //   return const <Card>[];
    // }
    PostController pc = Get.put(PostController());
    List<PostModel> posts = pc.myposts;
    // print("testing profile page");
    // print(products.length);

    return posts.map((post) {
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

  List<GestureDetector> _buildSavedCards(BuildContext context) {
    // if (products.isEmpty) {
    //   return const <Card>[];
    // }
    PostController pc = Get.put(PostController());
    List<PostModel> posts = pc.savedposts;
    print("testing saved posts page");
    print(posts.length);

    return posts.map((post) {
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

  Future<void> updateUserName(String? uid) async {
    return await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .update({'name': inputText.toString()});
    // print('${FirebaseFirestore.instance.collection('user').doc(uid).get("name")}');
  }

  @override
  Widget build(BuildContext context) {
    final uc = Get.find<UserController>();
    // AuthController ac = Get.find();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return Text(
              '${uc.user.name}',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            );
          }),
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
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(50.0, 15.0, 50.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 35.0,
                          backgroundColor: Colors.lightBlueAccent,
                          backgroundImage: NetworkImage(
                              FirebaseAuth.instance.currentUser!.photoURL!),
                        ),
                        // Container(
                        //     width: Get.width / 2 - 30,
                        //     child: Row(
                        //       children: [
                        //         isEdit
                        //             ? Row(
                        //                 children: [
                        //                   SizedBox(
                        //                     width: 100,
                        //                     height: 60,
                        //                     child: TextField(
                        //                       // decoration: InputDecoration(
                        //                       //   labelText: '${user.name}',
                        //                       //   labelStyle: TextStyle(
                        //                       //     fontSize: 12,
                        //                       //   )
                        //                       // ),
                        //                       onChanged: (text) {
                        //                         setState(() {
                        //                           inputText = text;
                        //                         });
                        //                       },
                        //                     ),
                        //                   ),
                        //                   TextButton(
                        //                     child: Text('완료'),
                        //                     onPressed: () {
                        //                       setState(() {
                        //                         updateUserName(user.uid);
                        //                         print(inputText);
                        //                         ac.userInit
                        //                             .getUser(ac.user!, false);
                        //                         isEdit = !isEdit;
                        //                       });
                        //                     },
                        //                   )
                        //                 ],
                        //               )
                        //             : Row(
                        //                 children: [
                        //                   Obx(() {
                        //                     return Text('${uc.user.name}');
                        //                   }),
                        //                   TextButton(
                        //                     child: Text('수정'),
                        //                     onPressed: () {
                        //                       setState(() {
                        //                         isEdit = !isEdit;
                        //                       });
                        //                     },
                        //                   )
                        //                 ],
                        //               )
                        //       ],
                        //     )),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        Column(
                          children: [
                            Text(
                              '${Get.find<PostController>().myposts.length}',
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
                              '${uc.user.follower}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                              '${uc.user.following}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 110.0),
                    child: TextButton(
                      onPressed: () async {
                        await uc.follow(uc.user.uid!);
                      },
                      child: Text(
                        "FOLLOW",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: TabBar(tabs: [
                Tab(
                  child: Icon(
                    Icons.grid_view,
                    color: Colors.black,
                  ),
                ),
                Tab(
                  child: Icon(
                    Icons.work_outline_outlined,
                    color: Colors.black,
                  ),
                )
              ]),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  GridView.count(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(16.0),
                    childAspectRatio: 9.0 / 9.0,
                    children: _buildGridCards(context),
                  ),
                  GridView.count(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(16.0),
                    childAspectRatio: 1.0 / 1.0,
                    children: _buildSavedCards(context),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
