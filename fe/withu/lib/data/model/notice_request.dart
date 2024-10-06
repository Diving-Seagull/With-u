import 'notice_image_request.dart';

class NoticeRequest {
  final String title;
  final String content;
  final bool pinned;
  final List<NoticeImageRequest> images;

  NoticeRequest({
    required this.title,
    required this.content,
    required this.pinned,
    required this.images
  });

  factory NoticeRequest.fromJson(Map<String, dynamic> json){
    return NoticeRequest(
        title: json['title'],
        content: json['content'],
        pinned: json['pinned'],
        images: json['images']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'content': content,
      'pinned': pinned,
      'images': images
    };
  }
}