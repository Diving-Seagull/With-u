class NotificationRequest {
  final List<int> targetMemberIds;

  NotificationRequest({required this.targetMemberIds});

  factory NotificationRequest.fromJson(Map<String, dynamic> json){
    return NotificationRequest(
      targetMemberIds: json['targetMemberIds']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'targetMemberIds': targetMemberIds
    };
  }
}