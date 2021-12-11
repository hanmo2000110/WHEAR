import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whear/auth/auth_middleware.dart';
import 'package:whear/binding/binding.dart';
import 'package:whear/controller/post_controller.dart';
import 'package:whear/model/post_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  PostController pc = Get.put(PostController());

  // 상단 dropdown 변수
  final List<int> _dropdownList = [0, 1, 2, 3, 4, 5];
  int? _selectedValue = 0;

  Future<void> _onRefresh() async {
    await pc.getWheatherPosts(_selectedValue!);
    await Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {});
      print("search page reloading is finished");
    });
  }

  List<GestureDetector> _buildGridCards(BuildContext context) {
    // final firebaseauth = Provider.of<ApplicationState>(context);
    PostController pc = Get.put(PostController());
    List<PostModel> products = pc.wheatherposts;
    // final ThemeData theme = Theme.of(context);

    return products.map((post) {
      return GestureDetector(
        onTap: () {
          Get.toNamed("detail", arguments: post);
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          // TODO: Adjust card heights (103)
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
                        padding: const EdgeInsets.all(3),
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
                  )
                  // Icon(
                  //   Icons.cloud,
                  //   color: Colors.blue,
                  // ),
                  ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '게시글 검색',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          DropdownButton(
              value: _selectedValue,
              items: _dropdownList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Container(
                    child: Image.asset(
                      'assets/icons/$value.jpg',
                      height: 30,
                      width: 30,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value as int;
                  // pc.getWheatherPosts(_selectedValue!);
                  _onRefresh();
                });
              })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        key: refreshKey,
        child: ListView(
          children: [
            GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(0.0),
              childAspectRatio: 1,
              children: _buildGridCards(context),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
          ],
        ),
      ),
    );
  }
}
