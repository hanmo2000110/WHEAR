import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:whear/model/user_model.dart';

class UserController extends GetxController {
  final Rx<UserModel> _userModel = UserModel().obs;

  // @override
  // onInit() {
  //   print("Get Data according to the user");
  //   AuthController ac = Get.put(AuthController());
  //   ac.listen
  // }

  UserModel get user => _userModel.value;

  set user(UserModel value) => _userModel.value = value;

  void clear() {
    print("User Controller - Model Clearaed");
    _userModel.value = UserModel();
    _userModel.value.initalized = false;
  }

  Future<int> countFollowers(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // print("fu");
    final usersRef = await firestore
        .collection('user')
        .doc(uid)
        .collection("follower")
        .snapshots()
        .first;
    // print("ck");

    return usersRef.docs.length;
  }

  Future<int> follow(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String myuid = FirebaseAuth.instance.currentUser!.uid;
    final usersRef = firestore
        .collection('user')
        .doc(myuid)
        .collection("following")
        .doc(uid);

    print(uid);

    usersRef.get().then((docSnapshot) async {
      if (docSnapshot.exists) {
        usersRef.delete();
        print("follow deleted");
      } else {
        usersRef.set({
          "savedTime": Timestamp.now(),
          "uid": uid,
        });
        print("follow added");
      }
    });

    final refUser =
        firestore.collection('user').doc(uid).collection("follower").doc(myuid);

    print(uid);

    usersRef.get().then((docSnapshot) async {
      if (docSnapshot.exists) {
        refUser.delete();
        print("follow deleted");
      } else {
        refUser.set({
          "savedTime": Timestamp.now(),
          "uid": myuid,
        });
        print("follow added");
      }
    });

    return 0;
  }

  Future<int> countFollowings(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // print("fu");
    final usersRef = await firestore
        .collection('user')
        .doc(uid)
        .collection("following")
        .snapshots()
        .first;
    // print("ck");

    return usersRef.docs.length;
  }
}
