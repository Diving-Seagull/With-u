class NoticeImageRequest {
  final String base64Data;
  final String contentType;

  NoticeImageRequest({required this.base64Data, required this.contentType});


  factory NoticeImageRequest.fromJson(Map<String, dynamic> json){
    return NoticeImageRequest(
        base64Data: json['base64Data'],
        contentType: json['contentType']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'base64Data': base64Data,
      'contentType': contentType
    };
  }

}