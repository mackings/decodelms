class AllCourse {
  String message;
  List<Coursem> courses;
  int totalPages;
  int totalCourses;
  int currentPage;

  AllCourse({
    required this.message,
    required this.courses,
    required this.totalPages,
    required this.totalCourses,
    required this.currentPage,
  });

  factory AllCourse.fromJson(Map<String, dynamic> json) {
    return AllCourse(
      message: json['message'] ?? '',
      courses: (json['courses'] as List<dynamic>)
          .map((course) => Coursem.fromJson(course))
          .toList(),
      totalPages: json['totalPages'] ?? 0,
      totalCourses: json['totalCourses'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
    );
  }
}

class Coursem {
  String id;
  String userId;
  String courseTitle;
  String courseDescription;
  String courseLanguage;
  List<dynamic> reviews;
  List<CourseImage> courseImage;
  String isPaidCourse;
  int isPriceCourse;
  List<Module> modules;
  int totalRegisteredByStudent;
  String createdAt;
  String updatedAt;
  bool isUploadedCompleted;

  Coursem({
    required this.id,
    required this.userId,
    required this.courseTitle,
    required this.courseDescription,
    required this.courseLanguage,
    required this.reviews,
    required this.courseImage,
    required this.isPaidCourse,
    required this.isPriceCourse,
    required this.modules,
    required this.totalRegisteredByStudent,
    required this.createdAt,
    required this.updatedAt,
    required this.isUploadedCompleted,
  });

  factory Coursem.fromJson(Map<String, dynamic> json) {
    return Coursem(
      id: json['_id'],
      userId: json['userId'],
      courseTitle: json['course_title'],
      courseDescription: json['course_description'],
      courseLanguage: json['course_language'],
      reviews: json['reviews'],
      courseImage: (json['course_image'] as List<dynamic>)
          .map((image) => CourseImage.fromJson(image))
          .toList(),
      isPaidCourse: json['isPaid_course'],
      isPriceCourse: json['isPrice_course'],
      modules: (json['modules'] as List<dynamic>)
          .map((module) => Module.fromJson(module))
          .toList(),
      totalRegisteredByStudent: json['totalRegisteredByStudent'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isUploadedCompleted: json['isUploadedCompleted']
    );
  }
}

class CourseImage {
  String fieldName;
  String originalName;
  String encoding;
  String mimeType;
  String path;
  int size;
  String filename;

  CourseImage({
    required this.fieldName,
    required this.originalName,
    required this.encoding,
    required this.mimeType,
    required this.path,
    required this.size,
    required this.filename,
  });

  factory CourseImage.fromJson(Map<String, dynamic> json) {
    return CourseImage(
      fieldName: json['fieldname'],
      originalName: json['originalname'],
      encoding: json['encoding'],
      mimeType: json['mimetype'],
      path: json['path'],
      size: json['size'],
      filename: json['filename'],
    );
  }
}

class Module {
  String userId;
  String courseId;
  String moduleTitle;
  String moduleDescription;
  List<Video> video;
  List<CourseImage> image;
  List<CourseImage> audio;
  String moduleDuration;
  List<dynamic> quizzes;
  List<dynamic> comments;
  List<dynamic> likeAndDislikeUsers;
  int commentCount;
  List<dynamic> commentId;
  int likeCount;
  int dislikeCount;
  String id;
  String createdAt;
  String updatedAt;

  Module({
    required this.userId,
    required this.courseId,
    required this.moduleTitle,
    required this.moduleDescription,
    required this.video,
    required this.image,
    required this.audio,
    required this.moduleDuration,
    required this.quizzes,
    required this.comments,
    required this.likeAndDislikeUsers,
    required this.commentCount,
    required this.commentId,
    required this.likeCount,
    required this.dislikeCount,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      userId: json['userId'],
      courseId: json['courseId'],
      moduleTitle: json['module_title'],
      moduleDescription: json['module_description'],
      video: (json['video'] as List<dynamic>)
          .map((v) => Video.fromJson(v))
          .toList(),
      image: (json['image'] as List<dynamic>)
          .map((image) => CourseImage.fromJson(image))
          .toList(),
      audio: (json['audio'] as List<dynamic>)
          .map((audio) => CourseImage.fromJson(audio))
          .toList(),
      moduleDuration: json['module_duration'],
      quizzes: json['quizzes'],
      comments: json['comments'],
      likeAndDislikeUsers: json['likeAndDislikeUsers'],
      commentCount: json['comment_count'],
      commentId: json['commentId'],
      likeCount: json['like_count'],
      dislikeCount: json['dislike_count'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Video {
  String fieldName;
  String originalName;
  String encoding;
  String mimeType;
  String path;
  int size;
  String filename;

  Video({
    required this.fieldName,
    required this.originalName,
    required this.encoding,
    required this.mimeType,
    required this.path,
    required this.size,
    required this.filename,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      fieldName: json['fieldname'],
      originalName: json['originalname'],
      encoding: json['encoding'],
      mimeType: json['mimetype'],
      path: json['path'],
      size: json['size'],
      filename: json['filename'],
    );
  }
}
