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
  String post_lookType = '데일리';
  XFile? imageXfile;
  Image? postImage;
  List<Asset> imageList = [];

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

    getMultiImage() async {
      List<Asset> resultList = [];
      resultList = await MultiImagePicker.pickImages(
          maxImages: 10, enableCamera: true, selectedAssets: imageList);
      setState(() {
        imageList = resultList;
      });
    }

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
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
                  height: Get.height / 2.5,
                  width: Get.width,
                  child: imageList.isEmpty == false
                      ? CarouselSlider(
                          options: CarouselOptions(height: 400.0),
                          items: imageList
                              .map((e) => AssetThumb(
                                    asset: e,
                                    width: 200,
                                    height: 200,
                                  ))
                              .toList(),
                        )
                      : const Center(
                          child: Text(
                            "이미지를 선택해주세요",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                ),
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
                        // initialValue: '데일리',
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.checkroom,
                                size: 18,
                                color: Colors.blue,
                              ),
                              const SizedBox(
                                width: 5,
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
    User? currentUser = ac.user;
    var docid;
    final now = FieldValue.serverTimestamp();

    await posts
        .add(({
      "content": post_content,
      'ctime': now,
      'creator': currentUser?.uid,
      'look_type': post_lookType,
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
        "docid": docid,
      });
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
