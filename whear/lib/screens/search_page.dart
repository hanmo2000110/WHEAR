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
  final searchText = TextEditingController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  PostController pc = Get.put(PostController());

  Future<void> _onRefresh() async {
    await pc.getPosts();
    setState(() {});
  }

  List<Card> _buildGridCards(BuildContext context) {
    // final firebaseauth = Provider.of<ApplicationState>(context);
    PostController pc = Get.put(PostController());
    List<PostModel> products = pc.searchposts;
    // print(products[0].image_links[0]);

    // if (products.isEmpty) {
    //   return const <Card>[];
    // }

    final ThemeData theme = Theme.of(context);
    // final NumberFormat formatter = NumberFormat.simpleCurrency(
    //     locale: Localizations.localeOf(context).toString());

    return products.map((post) {
      return Card(
        clipBehavior: Clip.antiAlias,
        // TODO: Adjust card heights (103)
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Image.network(
              "${post.image_links[0]}",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
            Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.cloud,
                    color: Colors.blue,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFe0f2f1),
                  ),
                )
                // Icon(
                //   Icons.cloud,
                //   color: Colors.blue,
                // ),
                ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          width: Get.width,
          child: Row(
            children: [
              Flexible(
                child: Container(
                  height: 40,
                  child: TextField(
                    controller: searchText,
                    // cursorHeight: 30,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.cloud,
                color: Colors.blue,
              ),
            ],
          ),
        ),
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
