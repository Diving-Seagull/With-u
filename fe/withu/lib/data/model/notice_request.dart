class NoticeRequest {
  final String title;
  final String content;
  final List<String> imageUrls;

  NoticeRequest({
    required this.title,
    required this.content,
    required this.imageUrls
  });

  factory NoticeRequest.fromJson(Map<String, dynamic> json){
    return NoticeRequest(
        title: json['title'],
        content: json['content'],
        imageUrls: json['imageUrls']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'content': content,
      'imageUrls': imageUrls
    };
  }
}