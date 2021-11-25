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
    super.onInit();
  }

  List<PostModel> _myPosts = [];
  List<PostModel> get myposts => _myPosts;

  Future getMyPosts() async {
    UserController uc = Get.find<UserController>();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    _myPosts.clear();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print(uid);
    var result = await firestore
        .collection('posts')
        .where("creator", isEqualTo: uid)
        .get();
    print("now testing postcontroller");

    result.docs.forEach((element) {
      print(element.data()['creator']);
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
    print(_myPosts.length);
  }
}

// PostModel(
//             post_id: element.doc.data()['docid'],
//             creator: element.data()["creator"],
//             createdTime: element.data()["ctime"] as Timestamp,
//             wheather: element.data()["wheather"],
//             lookType: element.data()['looktype'],
//             image_links: element.data()['image_links'],
//             content: element.data()['content'],
//             //TODO: 이거 커멘트 타입 정해야함 !!!!!!
//           )

// _postListener =
//     firestore.collection("posts").snapshots().listen((change) {
//       querySnapshot.documentChanges.forEach((change){

//       }
//     })
//     snapshots().listen((event) {
//   final doc = event.data();
//   _allPosts = (doc as LinkedHashMap).keys.map((post_id) {
//     return PostModel(
//       post_id: post_id,
//       creator: doc![post_id]["creator"],
//       createdTime: doc[post_id]["createdTime"] as Timestamp,
//       wheather: doc[post_id]["wheather"],
//       lookType: doc[post_id]['looktype'],
//       liker: doc[post_id]['liker'],
//       content: doc[post_id]['content'],
//       like: doc[post_id]['like'],
//       //TODO: 이거 커멘트 타입 정해야함 !!!!!!
//       comment: doc[post_id]['comment'],
//     );
//   }).toList();
// });
// await completer.future;
