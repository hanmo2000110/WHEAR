import 'dart:html';

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
  String? content;
  int? like;
  List<String>? liker;
  List<CommentModel>? comment;

  PostModel({
    required this.post_id,
    required this.creator,
    required this.createdTime,
    this.liker,
    this.content,
    this.like,
    required this.wheather,
    this.comment,
  });

  PostModel.fromJson(Map<String, dynamic> json)
      : post_id = json['post_id'],
        creator = json['creator'],
        createdTime = json['createdtime'],
        liker = json['liker'],
        content = json['content'],
        like = json['like'],
        wheather = json['wheather'],
        comment = (json['comment'].map((json) => CommentModel.fromJson(json)))
            .toList();

  Map<String, dynamic> toJson() => {
        'post_id': post_id,
        'creator': creator,
        'createdtime': createdTime,
        'liker': liker,
        'content': content,
        'like': like,
        'wheather': wheather,
        'comment':
            (comment?.map((comment_model) => comment_model.toJson()))?.toList(),
      };

  @override
  String toString() => "${creator ?? 'Anon'} (post_id=$post_id)";
}
