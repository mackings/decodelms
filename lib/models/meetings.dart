class Meeting {
  final String id;
  final String instructor;
  final String date;
  final String time;
  final String description;
  final String courseId;
  final String courseName;
  final String room;
  final String createdAt;
  final String updatedAt;

  Meeting({
    required this.id,
    required this.instructor,
    required this.date,
    required this.time,
    required this.description,
    required this.courseId,
    required this.courseName,
    required this.room,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['_id'],
      instructor: json['instructor'],
      date: json['date'],
      time: json['time'],
      description: json['description'],
      courseId: json['courseId'],
      courseName: json['courseName'],
      room: json['room'] ?? json['roomId'], // Handle variations in the field name
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
