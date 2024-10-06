class NoticeImage {
  final int id;
  final int order;
  final String imageData;
  final String contentType;

  NoticeImage({required this.id, required this.order, required this.imageData, required this.contentType});


  factory NoticeImage.fromJson(Map<String, dynamic> json){
    return NoticeImage(
        imageData: json['imageData'],
        contentType: json['contentType'],
      id: json['id'],
      order: json['order']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'imageData': imageData,
      'contentType': contentType,
      'id': id,
      'order': order
    };
  }
}