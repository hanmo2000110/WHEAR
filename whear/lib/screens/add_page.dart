import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:whear/auth/auth_middleware.dart';
import 'package:whear/binding/binding.dart';
import 'package:whear/controller/auth_controller.dart';
import 'package:whear/controller/bottom_navigation_controller.dart';
import 'package:whear/controller/post_controller.dart';
import 'package:whear/controller/user_controller.dart';
import 'package:whear/model/post_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  BottomNavigationController bc = Get.find();
  String post_content = '';
  int post_weatherType = -1;
  String post_lookType = '데일리';
  XFile? imageXfile;
  Image? postImage;
  List<Asset> imageList = [];

  List<Image> wimages = [
    for (int i = 0; i < 5; i++)
      Image.asset(
        'assets/icons/$i.jpg',
        height: 30,
        width: 30,
      ),
  ];

  List<String> lookTypes = ['데일리', '아메카지', '락시크', '포멀'];

  @override
  Widget build(BuildContext context) {
    getPhoto() async {
      ImagePicker _picker = ImagePicker();
      XFile? _pickedImage =
          (await _picker.pickImage(source: ImageSource.gallery));
      setState(() {
        imageXfile = _pickedImage;
        postImage = Image.file(File(_pickedImage!.path));
      });
    }

    getMultiImage() async {
      List<Asset> resultList = [];
      resultList = await MultiImagePicker.pickImages(
          maxImages: 10, enableCamera: true, selectedAssets: imageList);
      setState(() {
        imageList = resultList;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.white,
        title: const Text(
          'WHEAR',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
            size: 16,
          ),
          onPressed: () {
            bc.changeTabIndex(0);
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              '공유',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            onPressed: () async {
              if (post_weatherType == -1) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('오늘의 날씨를 선택해주세요.',
                        style: TextStyle(fontSize: 17))));
                return;
              }
              await addPost(
                imagelist: imageList,
                post_content: post_content,
                post_lookType: post_lookType,
                post_weatherType: post_weatherType,
              );
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text('게시글이 업로드 되었습니다!', style: TextStyle(fontSize: 17))));
              bc.changeTabIndex(0);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              InkWell(
                child: SizedBox(
                    height: Get.width,
                    width: Get.width,
                    child: imageList.isEmpty == false
                        ? CarouselSlider(
                            options: CarouselOptions(
                              aspectRatio: 10 / 10,
                              viewportFraction: 1.0,
                              height: 400.0,
                              enableInfiniteScroll: false,
                            ),
                            items: imageList
                                .map((e) => AssetThumb(
                                      asset: e,
                                      width: 200,
                                      height: 200,
                                    ))
                                .toList(),
                          )
                        : const Center(
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              size: 30,
                            ),
                          )),
                onTap: () async {
                  await getMultiImage();
                },
                splashColor: Colors.transparent,
              ),
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: PopupMenuButton(
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.checkroom,
                                size: 18,
                                color: Colors.indigoAccent,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                post_lookType,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.indigoAccent,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        onSelected: (result) {
                          setState(() {
                            post_lookType = result.toString();
                          });
                        },
                        itemBuilder: (BuildContext context) => lookTypes
                            .map((value) => PopupMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    // Divider(
                    //   color: Colors.grey.shade800,
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < wimages.length; i++)
                            // IconButton(onPressed: () {}, icon: wi),
                            OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    post_weatherType = i;
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: wimages[i],
                                ),
                                style: OutlinedButton.styleFrom(
                                  elevation: i != post_weatherType ? 0 : 3,
                                  shape: const CircleBorder(),
                                  side: const BorderSide(
                                      width: 1, color: Colors.transparent
                                      //     : Colors.blue,
                                      ),
                                )),
                        ],
                      ),
                    ),
                    // Divider(
                    //   color: Colors.grey.shade800,
                    // ),
                    // TextField(
                    //   // keyboardType: TextInputType.multiline,
                    //   maxLines: null,
                    //   decoration: const InputDecoration(
                    //     labelText: "내용 입력...",
                    //     labelStyle: TextStyle(fontSize: 14),
                    //     fillColor: Colors.black,
                    //     focusColor: Colors.black,
                    //     hoverColor: Colors.black,
                    //   ),
                    //   autocorrect: false,
                    //   onChanged: (value) {
                    //     post_content = value;
                    //   },
                    //   onSubmitted: (value) {
                    //     post_content = value;
                    //   },
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      cursorColor: Colors.grey,
                      keyboardType: TextInputType
                          .multiline, // user keyboard will have a button to move cursor to next line
                      autocorrect: false,
                      decoration: const InputDecoration(
                          hintText: '내용 입력...',
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.grey,
                          focusColor: Colors.grey,
                          hoverColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          )),
                      onChanged: (value) {
                        post_content = value;
                      },
                      onFieldSubmitted: (value) {
                        post_content = value;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<void> addPost({
    required List<Asset>? imagelist,
    required String post_content,
    required int post_weatherType,
    required String post_lookType,
  }) async {
    CollectionReference posts = FirebaseFirestore.instance.collection("posts");
    int id = 0;
    PostController pc = Get.put(PostController());
    AuthController ac = Get.find<AuthController>();
    UserController uc = Get.find<UserController>();
    var docid;
    final now = FieldValue.serverTimestamp();

    await posts
        .add(({
      "content": post_content,
      'createdTime': now,
      'creator': uc.user.uid,
      // 'creatorProfilePhotoURL': uc.user.profile_image_url,
      'lookType': post_lookType,
      'weather': post_weatherType,
      "image_links": []
      // 'photoUrl': url,
    }))
        .then((value) async {
      print(value.id);
      docid = value.id;
      var list = await uploadImageToStorage(imagelist!, docid);
      posts.doc(docid).update({
        "image_links": list,
        "post_id": docid,
      });
      await pc.getMyPosts();
    });
    // appstate.loadProducts(ddp.sortingway);
  }

  Future<List<String>> uploadImageToStorage(
      List<Asset> list, String docid) async {
    List<String> downloadLinks = [];
    for (var asset in list) {
      var pi = await post_Image(asset, docid);
      downloadLinks.add(pi);
    }
    print(downloadLinks.length);
    return downloadLinks;
  }

  Future<String> post_Image(Asset imageFile, String docid) async {
    var downloadURL;
    try {
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('product/$docid') //'post'라는 folder를 만들고
          .child('${DateTime.now().millisecondsSinceEpoch}.png');

      // 파일 업로드
      final uploadTask = firebaseStorageRef
          .putData((await imageFile.getByteData()).buffer.asUint8List());

      // 완료까지 기다림
      await uploadTask.whenComplete(() => null);

      // 업로드 완료 후 url
      downloadURL = await (await uploadTask).ref.getDownloadURL();
      print(downloadURL);
      return downloadURL;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
    return downloadURL;
  }
}
