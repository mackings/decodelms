class Course {
  final String id;
  final String title;
  final String description;
  final String imageUrl; // Change imageUrl to a String

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    // Extract the first course image URL from the list
    String imageUrl = json['image'] is List
        ? (json['image'][0]['path']
            as String) // Use the 'path' property for the image URL
        : '';

    return Course(
      id: json['courseId'],
      title: json['title'],
      description: json['description'],
      imageUrl: imageUrl,
    );
  }
}
