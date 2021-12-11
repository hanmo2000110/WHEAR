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
    await getPosts();
    await getMyPosts();

    await getWheatherPosts(0);
    print("getposts finished");

    super.onInit();
  }

  List<PostModel> _myPosts = [];
  List<PostModel> get myposts => _myPosts;

  List<PostModel> _searchPosts = [];
  List<PostModel> get searchposts => _searchPosts;

  List<PostModel> _wheatherPosts = [];
  List<PostModel> get wheatherposts => _wheatherPosts;

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
    // print("now testing my postcontroller");

    result.docs.forEach((element) async {
      // print(element.data()['creator']);
      String creatorName = await getCreatorInfo(uid);
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
      _myPosts.add(post);
      // print(element.data()['image_links'].cast<String>()[0]);
    });
    // print(_myPosts.length);
  }

  Future getPosts() async {
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
      post.likes = await countLike(post.post_id);
      post.iLiked = await iLiked(post.post_id);
      post.iSaved = await iSaved(post.post_id);
      _searchPosts.add(post);
      // print(element.data()['image_links'].cast<String>()[0]);
    });

    print(_searchPosts.length);
  }

  Future getWheatherPosts(int search_wheather) async {
    UserController uc = Get.find<UserController>();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    _wheatherPosts.clear();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var result = await firestore
        .collection('posts')
        .where("weather", isEqualTo: search_wheather)
        .orderBy('createdTime', descending: true)
        .get();

    result.docs.forEach((element) {
      _wheatherPosts.add(PostModel(
        createdTime: element.data()['createdTime'],
        creator: element.data()['creator'],
        post_id: element.data()['post_id'],
        lookType: element.data()['lookType'],
        wheather: element.data()['weather'],
        content: element.data()['content'],
        image_links: element.data()['image_links'].cast<String>(),
      ));
    });
  }

  Future<String> getCreatorInfo(String creator) async {
    var creatorInfo = await firestore.collection('user').doc(creator).get();
    return creatorInfo['name'];
  }

  Future<bool> like(String docid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final usersRef =
        firestore.collection('posts').doc(docid).collection("like").doc(uid);
    print(docid);
    usersRef.get().then((docSnapshot) async {
      if (docSnapshot.exists) {
        usersRef.delete();
        print("like deleted");
        return false;
      } else {
        usersRef.set({"likedTime": Timestamp.now()});
        print("like added");
        return true;
      }
    });
    return false;
  }

  Future<int> countLike(String docid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // print("fu");
    final usersRef = await firestore
        .collection('posts')
        .doc(docid)
        .collection("like")
        .snapshots()
        .first;
    // print("ck");

    return usersRef.docs.length;
  }

  Future<bool> iLiked(String docid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // print(docid);
    final usersRef = await firestore
        .collection('posts')
        .doc(docid)
        .collection("like")
        .doc(uid)
        .get();
    // print("ck");

    return usersRef.exists;
  }

  Future<bool> savePost(String docid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final usersRef = firestore
        .collection('user')
        .doc(uid)
        .collection("savedPost")
        .doc(docid);

    print(docid);

    usersRef.get().then((docSnapshot) async {
      if (docSnapshot.exists) {
        usersRef.delete();
        print("save deleted");
        return false;
      } else {
        usersRef.set({"savedTime": Timestamp.now()});
        print("save added");
        return true;
      }
    });
    return false;
  }

  Future<bool> iSaved(String docid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // print(docid);
    final usersRef = await firestore
        .collection('user')
        .doc(uid)
        .collection("savedPost")
        .doc(docid)
        .get();
    // print("ck");

    return usersRef.exists;
  }
}
