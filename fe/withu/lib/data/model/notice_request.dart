class NoticeRequest {
  final String title;
  final String content;

  NoticeRequest({
    required this.title,
    required this.content
  });

  factory NoticeRequest.fromJson(Map<String, dynamic> json){
    return NoticeRequest(
        title: json['title'],
        content: json['content']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'content': content
    };
  }
}