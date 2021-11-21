import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whear/auth/auth_middleware.dart';
import 'package:whear/binding/binding.dart';
import 'package:whear/controller/auth_controller.dart';
import 'package:whear/controller/bottom_navigation_controller.dart';
import 'package:whear/controller/post_controller.dart';
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
  String post_content = 'Unknown';
  int post_weatherType = -1;
  String post_lookType = ' 룩을 선택해주세요';
  XFile? imageXfile;
  Image? postImage;

  List<Icon> wicons = [
    const Icon(Icons.wb_sunny),
    const Icon(Icons.wb_twighlight),
    const Icon(Icons.wb_cloudy_outlined),
    const Icon(Icons.wb_cloudy),
    const Icon(Icons.snowmobile),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '게시글 작성',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: TextButton(
          child: const Text(
            '취소',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          onPressed: () {
            bc.changeTabIndex(0);
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              '저장',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            onPressed: () async {
              await addPost(
                imageXfile: imageXfile,
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
      body: Center(
        child: Column(
          children: [
            InkWell(
              child: SizedBox(
                height: Get.height / 2.5,
                width: Get.width,
                child: postImage ??
                    const Center(
                      child: Text(
                        "이미지를 선택해주세요",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
              ),
              onTap: () {
                getPhoto();
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
                              Icons.add,
                              size: 18,
                              color: Colors.blue,
                            ),
                            Text(
                              post_lookType,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: Colors.blue,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      // OutlinedButton.icon(
                      //     onPressed: () {},
                      //     icon: const Icon(Icons.add, size: 18),
                      //     label: const Text(
                      //       "어떤 룩인지 선택해주세요",
                      //       style: TextStyle(color: Colors.black, fontSize: 16),
                      //     ),
                      //     style: OutlinedButton.styleFrom(
                      //       shape: const RoundedRectangleBorder(
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10))),
                      //       side:
                      //           const BorderSide(width: 1, color: Colors.blue),
                      //     )),
                      onSelected: (result) {
                        setState(() {
                          post_lookType = result.toString();
                        });
                      },
                      itemBuilder: (BuildContext context) => lookTypes
                          .map((value) => PopupMenuItem(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade800,
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < wicons.length; i++)
                        // IconButton(onPressed: () {}, icon: wi),
                        OutlinedButton(
                            onPressed: () {
                              setState(() {
                                post_weatherType = i;
                              });
                            },
                            child: wicons[i],
                            style: OutlinedButton.styleFrom(
                              shape: const CircleBorder(),
                              side: BorderSide(
                                width: 1,
                                color: i != post_weatherType
                                    ? Colors.transparent
                                    : Colors.blue,
                              ),
                            )),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade800,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "내용을 입력해주세요",
                    ),
                    autocorrect: false,
                    onChanged: (value) {
                      post_content = value;
                    },
                    onSubmitted: (value) {
                      post_content = value;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<void> addPost({
    required XFile? imageXfile,
    required String post_content,
    required int post_weatherType,
    required String post_lookType,
  }) async {
    int id = 0;
    PostController pc = Get.put(PostController());
    AuthController ac = Get.find<AuthController>();
    User? currentUser = ac.user;

    List<int> ids = [];
    for (PostModel p in pc.posts) {
      ids.add(p.post_id);
    }

    if (ids.isEmpty) {
      id = 0;
    } else {
      ids.sort();
      id = ids[ids.length - 1] + 1;
    }

    Map<String, dynamic> _postModel = {
      '$id.post_id': id,
      '$id.createdtime': FieldValue.serverTimestamp(),
      '$id.creator': currentUser != null ? currentUser.uid : "NULL",
      '$id.content': post_content,
      '$id.wheather': post_weatherType,
      '$id.looktype': post_lookType,
      '$id.like': 0,
      '$id.likeduser': [],
    };

    await uploadProductToStore(
      newProduct: _postModel,
    );

    if (imageXfile == null) {
      // var url = "http://handong.edu/site/handong/res/img/logo.png";
      // var imageId = await ImageDownloader.downloadImage(url);
      // var path = await ImageDownloader.findPath(imageId!);
      // await uploadImageToStorage(path!, id.toString());
    } else {
      await uploadImageToStorage(imageXfile.path, id.toString());
    }
  }

  Future<void> uploadImageToStorage(String filePath, String id) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('product/$id.jpeg')
          .putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      e.code == 'canceled';
    }
  }

  Future<void> uploadProductToStore({
    required Map<String, Object?> newProduct,
  }) async {
    FirebaseFirestore.instance
        .collection('post')
        .doc('posts')
        .update(newProduct);
  }
}
