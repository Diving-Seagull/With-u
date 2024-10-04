class NoticeImage {
  final int id;
  final String imageUrl;
  final int order;

  NoticeImage({required this.id, required this.imageUrl, required this.order});

  factory NoticeImage.fromJson(Map<String, dynamic> json){
    return NoticeImage(
        id: json['id'],
        imageUrl: json['imageUrl'],
        order: json['order']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'imageUrl': imageUrl,
      'order': order
    };
  }

}