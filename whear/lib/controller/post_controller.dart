import 'dart:async';
import 'dart:collection';

import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whear/controller/user_controller.dart';
import 'package:whear/model/post_model.dart';

class PostController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _postListener;

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

    _postListener =
        firestore.collection("post").doc("posts").snapshots().listen((event) {
      final doc = event.data();
      _allPosts = (doc as LinkedHashMap).keys.map((post_id) {
        return PostModel(
          post_id: int.parse(post_id),
          creator: doc![post_id]["creator"],
          createdTime: doc[post_id]["createdTime"] as Timestamp,
          wheather: doc[post_id]["wheather"],
          lookType: doc[post_id]['looktype'],
          liker: doc[post_id]['liker'],
          content: doc[post_id]['content'],
          like: doc[post_id]['like'],
          //TODO: 이거 커멘트 타입 정해야함 !!!!!!
          comment: doc[post_id]['comment'],
        );
      }).toList();
    });
    await completer.future;
  }
}
