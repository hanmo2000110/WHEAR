import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whear/controller/user_controller.dart';
import 'package:whear/model/post_model.dart';

class PostController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _postListener;

  @override
  onInit() async {
    await getMyPosts();
    await getPosts();
    super.onInit();
  }

  List<PostModel> _myPosts = [];
  List<PostModel> get myposts => _myPosts;
  List<PostModel> _searchPosts = [];
  List<PostModel> get searchposts => _searchPosts;

  Future getMyPosts() async {
    UserController uc = Get.find<UserController>();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    _myPosts.clear();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // print(uid);
    var result = await firestore
        .collection('posts')
        .where("creator", isEqualTo: uid)
        .orderBy('createdTime', descending: true)
        .get();
    // print("now testing postcontroller");

    result.docs.forEach((element) {
      // print(element.data()['creator']);
      _myPosts.add(PostModel(
        createdTime: element.data()['createdTime'],
        creator: element.data()['creator'],
        post_id: element.data()['post_id'],
        lookType: element.data()['lookType'],
        wheather: element.data()['weather'],
        content: element.data()['content'],
        image_links: element.data()['image_links'].cast<String>(),
      ));
      // print(element.data()['image_links'].cast<String>()[0]);
    });
    // print(_myPosts.length);
  }

  Future getPosts() async {
    UserController uc = Get.find<UserController>();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    _searchPosts.clear();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print(uid);
    var result = await firestore
        .collection('posts')
        .orderBy('createdTime', descending: true)
        .get();
    print("now testing getPosts");

    result.docs.forEach((element) async {
      // print(element.data()['creator']);
      String creatorName = await getCreatorInfo(element.data()['creator']);
      PostModel post = PostModel(
        createdTime: element.data()['createdTime'],
        creator: element.data()['creator'],
        creatorName: creatorName,
        post_id: element.data()['post_id'],
        lookType: element.data()['lookType'],
        wheather: element.data()['weather'],
        content: element.data()['content'],
        image_links: element.data()['image_links'].cast<String>(),
      );
      var creator = await firestore.collection('user').doc(post.creator).get();
      post.setCreatorProfilePhotoURL = creator['profile_image_url'];
      _searchPosts.add(post);
      // print(element.data()['image_links'].cast<String>()[0]);
    });

    print(_searchPosts.length);
  }

  Future<String> getCreatorInfo(String creator) async {
    var creatorInfo = await firestore.collection('user').doc(creator).get();
    return creatorInfo['name'];
  }
}
