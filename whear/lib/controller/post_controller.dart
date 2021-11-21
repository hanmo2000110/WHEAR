import 'dart:async';
import 'dart:collection';

import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whear/controller/user_controller.dart';
import 'package:whear/model/post_model.dart';

class PostController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _postListener;

  @override
  onInit() {
    getProductInfo();
    super.onInit();
  }

  late List<PostModel> _allPosts;
  List<PostModel> get posts => _allPosts;

  Future getProductInfo() async {
    UserController uc = Get.find<UserController>();
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final completer = Completer<bool>();

    _postListener = firestore
        .collection("post")
        .where("creator", isEqualTo: uc.user.uid)
        .snapshots();

    _postListener.listen((event) {
      final docs = event.docs;
      _allPosts = (docs as LinkedHashMap).keys.map((post_id) {
        return PostModel(
            post_id: post_id,
            creator: docs[post_id]["creator"],
            createdTime: docs[post_id]["createdTime"],
            wheather: docs[post_id]["wheather"]);
      }).toList();
    });
    await completer.future;
  }
}
