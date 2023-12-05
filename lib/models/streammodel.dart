class ApiResponse {
  final String message;
  final List<StudentCourse> result;

  ApiResponse({
    required this.message,
    required this.result,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> resultData = json['result'];
    final List<StudentCourse> result =
        resultData.map((courseData) => StudentCourse.fromJson(courseData)).toList();

    return ApiResponse(
      message: json['message'],
      result: result,
    );
  }
}

class StudentCourse {
  final String userId;
  final String courseId;
  final List<CourseModule> modules;

  StudentCourse({
    required this.userId,
    required this.courseId,
    required this.modules,
  });

  factory StudentCourse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> moduleData = json['module'];
    final List<CourseModule> modules =
        moduleData.map((module) => CourseModule.fromJson(module)).toList();

    return StudentCourse(
      userId: json['userId'],
      courseId: json['courseId'],
      modules: modules,
    );
  }
}

class CourseModule {
  final String id;
  final String moduleTitle;
  final String moduleDescription;
  final List<Video> video;
  final List<Image> image;
  final List<Audio> audio;
  final String moduleDuration;
  final List<String> quizzes;
  final int likeCount;
  final int dislikeCount;
  final bool isCompleted;

  CourseModule({
    required this.id,
    required this.moduleTitle,
    required this.moduleDescription,
    required this.video,
    required this.image,
    required this.audio,
    required this.moduleDuration,
    required this.quizzes,
    required this.likeCount,
    required this.dislikeCount,
    required this.isCompleted,
  });

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    final List<dynamic> videoData = json['video'];
    final List<Video> video =
        videoData.map((video) => Video.fromJson(video)).toList();

    final List<dynamic> imageData = json['image'];
    final List<Image> image =
        imageData.map((image) => Image.fromJson(image)).toList();

    final List<dynamic> audioData = json['audio'];
    final List<Audio> audio =
        audioData.map((audio) => Audio.fromJson(audio)).toList();

    return CourseModule(
      id: json['_id'],
      moduleTitle: json['module_title'],
      moduleDescription: json['module_description'],
      video: video,
      image: image,
      audio: audio,
      moduleDuration: json['module_duration'],
      quizzes: (json['quizzes'] as List<dynamic>).cast<String>(),
      likeCount: json['like_count'],
      dislikeCount: json['dislike_count'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class Video {
  final String fieldName;
  final String originalName;
  final String encoding;
  final String mimeType;
  final String path;
  final int size;
  final String filename;

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

class Image {
  final String fieldName;
  final String originalName;
  final String encoding;
  final String mimeType;
  final String path;
  final int size;
  final String filename;

  Image({
    required this.fieldName,
    required this.originalName,
    required this.encoding,
    required this.mimeType,
    required this.path,
    required this.size,
    required this.filename,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
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

class Audio {
  final String fieldName;
  final String originalName;
  final String encoding;
  final String mimeType;
  final String path;
  final int size;
  final String filename;

  Audio({
    required this.fieldName,
    required this.originalName,
    required this.encoding,
    required this.mimeType,
    required this.path,
    required this.size,
    required this.filename,
  });

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
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
