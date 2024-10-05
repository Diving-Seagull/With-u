class Schedule {
  final int id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String description;
  final String type;
  final int memberId;
  final String memberName;
  final int? teamId;

  Schedule({
    required this.id, required this.title,
    required this.startTime, required this.endTime,
    required this.description, required this.type,
    required this.memberId, required this.memberName,
    required this.teamId});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
        id: json['id'],
        title: json['title'],
        startTime: DateTime.parse(json['startTime']),
        endTime: DateTime.parse(json['endTime']),
        description: json['description'],
        type: json['type'],
        memberId: json['memberId'],
        memberName: json['memberName'],
        teamId: json['teamId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startTime': startTime,
      'description': description,
      'endTime': endTime,
      'type': type,
      'memberId': memberId,
      'memberName': memberName,
      'teamId': teamId
    };
  }

}