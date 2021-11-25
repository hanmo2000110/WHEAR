import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whear/auth/auth_middleware.dart';
import 'package:whear/binding/binding.dart';
import 'package:whear/model/post_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchText = TextEditingController();

  List<Card> _buildGridCards(BuildContext context) {
    // final firebaseauth = Provider.of<ApplicationState>(context);
    List<PostModel> posts = [
      PostModel(
        post_id: 0,
        createdTime: Timestamp.now(),
        creator: "",
        wheather: 100,
        lookType: "",
      ),
      PostModel(
        post_id: 0,
        createdTime: Timestamp.now(),
        creator: "",
        wheather: 100,
        lookType: "",
      ),
      PostModel(
        post_id: 0,
        createdTime: Timestamp.now(),
        creator: "",
        wheather: 100,
        lookType: "",
      ),
      PostModel(
        post_id: 0,
        createdTime: Timestamp.now(),
        creator: "",
        wheather: 100,
        lookType: "",
      )
    ];

    // if (products.isEmpty) {
    //   return const <Card>[];
    // }

    final ThemeData theme = Theme.of(context);
    // final NumberFormat formatter = NumberFormat.simpleCurrency(
    //     locale: Localizations.localeOf(context).toString());

    return posts.map((post) {
      return Card(
        clipBehavior: Clip.antiAlias,
        // TODO: Adjust card heights (103)
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIr7vw9HmTs3KqMz8kwUThJaRLsEtD4co30w&usqp=CAU",
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
      body: Column(
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
    );
  }
}
