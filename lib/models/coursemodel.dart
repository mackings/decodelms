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





class AllCourseResponse {
  final String message;
  final List<AllCourse> courses;
  final int totalPages;
  final int totalCourses;
  final int currentPage;

  AllCourseResponse({
    required this.message,
    required this.courses,
    required this.totalPages,
    required this.totalCourses,
    required this.currentPage,
  });

  factory AllCourseResponse.fromJson(Map<String, dynamic> json) {
    List<AllCourse> courses = (json['courses'] as List)
        .map((courseJson) => AllCourse.fromJson(courseJson))
        .toList();

    return AllCourseResponse(
      message: json['message'],
      courses: courses,
      totalPages: json['totalPages'],
      totalCourses: json['totalCourses'],
      currentPage: json['currentPage'],
    );
  }
}

class AllCourse {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int enrolled;
  final List<Module> modules;

  AllCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.enrolled,
    required this.modules,
  });

  factory AllCourse.fromJson(Map<String, dynamic> json) {
    List<Module> modulesList = (json['modules'] as List)
        .map((moduleJson) => Module.fromJson(moduleJson))
        .toList();

    // Extract the first course image URL from the list
    String imageUrl = json['course_image'] is List
        ? (json['course_image'][0]['path'] as String)
        : '';

    return AllCourse(
      id: json['_id'],
      title: json['course_title'],
      description: json['course_description'],
      enrolled: json['totalRegisteredByStudent'],
      imageUrl: imageUrl,
      modules: modulesList,
    );
  }
}

class Module {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String imageUrl;
  final String audioUrl;

  Module({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.imageUrl,
    required this.audioUrl,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    // Extract URLs for video, image, and audio,,
    String videoUrl =
        json['video'] is List ? (json['video'][0]['path'] as String) : '';
    String imageUrl =
        json['image'] is List ? (json['image'][0]['path'] as String) : '';
    String audioUrl =
        json['audio'] is List ? (json['audio'][0]['path'] as String) : '';

    return Module(
      id: json['_id'],
      title: json['module_title'],
      description: json['module_description'],
      videoUrl: videoUrl,
      imageUrl: imageUrl,
      audioUrl: audioUrl,
    );
  }
}