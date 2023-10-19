class CourseDetailResponse {
  final String message;
  final List<CourseModuleResponse> result;

  CourseDetailResponse({
    required this.message,
    required this.result,
  });

  factory CourseDetailResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> resultData = json['result'];
    final List<CourseModuleResponse> result = resultData
        .map((moduleData) => CourseModuleResponse.fromJson(moduleData))
        .toList();

    return CourseDetailResponse(
      message: json['message'],
      result: result,
    );
  }
}

class CourseModuleResponse {
  final String id;
  final String userId;
  final String courseId;
  final String moduleTitle;
  final String moduleDescription;
  final List<VideoResponse> video;
  final List<ImageResponse> image;
  final List<ImageResponse> audio;
  final List<QuestionResponse> questions;
  final List<dynamic> comments; // This might need to be updated based on actual data

  CourseModuleResponse({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.moduleTitle,
    required this.moduleDescription,
    required this.video,
    required this.image,
    required this.audio,
    required this.questions,
    required this.comments,
  });

  factory CourseModuleResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> videoData = json['video'];
    final List<VideoResponse> video =
        videoData.map((video) => VideoResponse.fromJson(video)).toList();

    final List<dynamic> imageData = json['image'];
    final List<ImageResponse> image =
        imageData.map((image) => ImageResponse.fromJson(image)).toList();

    final List<dynamic> audioData = json['audio'];
    final List<ImageResponse> audio =
        audioData.map((audio) => ImageResponse.fromJson(audio)).toList();

    final List<dynamic> questionData = json['questions'];
    final List<QuestionResponse> questions =
        questionData.map((question) => QuestionResponse.fromJson(question)).toList();

    return CourseModuleResponse(
      id: json['_id'],
      userId: json['userId'],
      courseId: json['courseId'],
      moduleTitle: json['module_title'],
      moduleDescription: json['module_description'],
      video: video,
      image: image,
      audio: audio,
      questions: questions,
      comments: json['comments'],
    );
  }
}

class VideoResponse {
  final String fieldName;
  final String originalName;
  final String encoding;
  final String mimeType;
  final String path;
  final int size;
  final String filename;

  VideoResponse({
    required this.fieldName,
    required this.originalName,
    required this.encoding,
    required this.mimeType,
    required this.path,
    required this.size,
    required this.filename,
  });

  factory VideoResponse.fromJson(Map<String, dynamic> json) {
    return VideoResponse(
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

class ImageResponse {
  final String fieldName;
  final String originalName;
  final String encoding;
  final String mimeType;
  final String path;
  final int size;
  final String filename;

  ImageResponse({
    required this.fieldName,
    required this.originalName,
    required this.encoding,
    required this.mimeType,
    required this.path,
    required this.size,
    required this.filename,
  });

  factory ImageResponse.fromJson(Map<String, dynamic> json) {
    return ImageResponse(
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

class QuestionResponse {
  final List<dynamic> options; // This might need to be updated based on actual data
  final String id;
  final String createdAt;
  final String updatedAt;

  QuestionResponse({
    required this.options,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuestionResponse.fromJson(Map<String, dynamic> json) {
    return QuestionResponse(
      options: json['options'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
