class NoticeRequest {
  final String title;
  final String content;
  final bool pinned;
  final List<String> imageUrls;

  NoticeRequest({
    required this.title,
    required this.content,
    required this.pinned,
    required this.imageUrls
  });

  factory NoticeRequest.fromJson(Map<String, dynamic> json){
    return NoticeRequest(
        title: json['title'],
        content: json['content'],
        pinned: json['pinned'],
        imageUrls: json['imageUrls']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'content': content,
      'pinned': pinned,
      'imageUrls': imageUrls
    };
  }
}