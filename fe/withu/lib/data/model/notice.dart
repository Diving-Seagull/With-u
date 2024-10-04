import 'package:withu/data/model/notice_image.dart';

class Notice {
  final int id;
  final int teamId;
  final String title;
  final String content;
  final int authorId;
  final String authorName;
  final List<NoticeImage> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notice(
      {required this.id,
      required this.teamId,
      required this.title,
      required this.content,
      required this.authorId,
      required this.authorName,
      required this.images,
      required this.createdAt,
      required this.updatedAt});

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
        id: json['id'],
        teamId: json['teamId'],
        title: json['title'],
        content: json['content'],
        authorId: json['authorId'],
        authorName: json['authorName'],
        images: (json['images'] as List).map((image) => NoticeImage.fromJson(image)).toList(),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teamId': teamId,
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'images': images,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
