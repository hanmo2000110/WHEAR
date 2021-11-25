// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:whear/model/comment_model.dart';

enum weatherType { SUNNY, WINDY, RAINY, CLOUDY, SNOWY }

class PostModel {
  String post_id;
  String creator;
  Timestamp createdTime;
  int wheather;
  String lookType;
  String? content;
  List<String> image_links;
  //TODO: 이거 커멘트 타입 정해야함 !!!!!!
  List<CommentModel>? comment;

  PostModel({
    required this.post_id,
    required this.creator,
    required this.createdTime,
    required this.lookType,
    required this.image_links,
    this.content,
    required this.wheather,
    this.comment,
  });

  PostModel.fromJson(Map<String, dynamic> json)
      : post_id = json['post_id'],
        creator = json['creator'],
        createdTime = json['createdtime'],
        image_links = json['image_links'],
        content = json['content'],
        lookType = json['looktype'],
        wheather = json['wheather'],
        comment = (json['comment'].map((json) => CommentModel.fromJson(json)))
            .toList();

  Map<String, dynamic> toJson() => {
        'post_id': post_id,
        'creator': creator,
        'createdtime': createdTime,
        'image_links': image_links,
        'content': content,
        'looktype': lookType,
        'wheather': wheather,
        //TODO: 이거 커멘트 타입 정해야함 !!!!!!
        'comment':
            (comment?.map((comment_model) => comment_model.toJson()))?.toList(),
      };

  @override
  String toString() => "$creator (post_id=$post_id)";
}
