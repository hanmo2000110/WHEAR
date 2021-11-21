class CommentModel {
  String comment;
  List<String>? re_comment;

  CommentModel({
    required this.comment,
    this.re_comment,
  });

  CommentModel.fromJson(Map<String, dynamic> json)
      : comment = json['comment'],
        re_comment = json['re_comment'];

  Map<String, dynamic> toJson() => {
        'comment': comment,
        're_comment': re_comment,
      };
}
