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




class AllCourse {
  final String id;
  final String title;
  final String description;
  final String isPaidCourse;
  final int totalRegisteredByStudent;
  final List<Module> modules;
  final String imageUrl;

  AllCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.isPaidCourse,
    required this.totalRegisteredByStudent,
    required this.modules,
    required this.imageUrl,
  });

  factory AllCourse.fromJson(Map<String, dynamic> json) {
    List<Module> modulesList = (json['modules'] as List)
        .map((moduleJson) => Module.fromJson(moduleJson))
        .toList();

    String imageUrl = json['course_image'] is List
        ? (json['course_image'][0]['path'] as String)
        : '';

    return AllCourse(
      id: json['_id'],
      title: json['course_title'],
      description: json['course_description'],
      isPaidCourse: json['isPaid_course'],
      totalRegisteredByStudent: json['totalRegisteredByStudent'],
      modules: modulesList,
      imageUrl: imageUrl,
    );
  }
}

class Module {
  final String userId;
  final String courseId;
  final String title;
  final String description;
  final List<Video> video;
  final List<dynamic> image; // Update the type based on the actual data type
  final List<Audio> audio;
  final String moduleDuration;
  final List<dynamic> quizzes; // Update the type based on the actual data type
  final List<dynamic> comments; // Update the type based on the actual data type
  final bool isCompleted;
  final List<dynamic> likeAndDislikeUsers; // Update the type based on the actual data type
  final int commentCount;
  final List<dynamic> commentId; // Update the type based on the actual data type
  final int likeCount;
  final int dislikeCount;
  final String id;
  final String createdAt;
  final String updatedAt;

  Module({
    required this.userId,
    required this.courseId,
    required this.title,
    required this.description,
    required this.video,
    required this.image,
    required this.audio,
    required this.moduleDuration,
    required this.quizzes,
    required this.comments,
    required this.isCompleted,
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
    List<Video> video = (json['video'] as List)
        .map((videoJson) => Video.fromJson(videoJson))
        .toList();

    List<Audio> audio = (json['audio'] as List)
        .map((audioJson) => Audio.fromJson(audioJson))
        .toList();

    return Module(
      userId: json['userId'],
      courseId: json['courseId'],
      title: json['module_title'],
      description: json['module_description'],
      video: video,
      image: json['image'],
      audio: audio,
      moduleDuration: json['module_duration'],
      quizzes: json['quizzes'],
      comments: json['comments'],
      isCompleted: json['isCompleted'],
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
  final String fieldname;
  final String originalname;
  final String encoding;
  final String mimetype;
  final String path;
  final int size;
  final String filename;

  Video({
    required this.fieldname,
    required this.originalname,
    required this.encoding,
    required this.mimetype,
    required this.path,
    required this.size,
    required this.filename,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      fieldname: json['fieldname'],
      originalname: json['originalname'],
      encoding: json['encoding'],
      mimetype: json['mimetype'],
      path: json['path'],
      size: json['size'],
      filename: json['filename'],
    );
  }
}

class Audio {
  final String fieldname;
  final String originalname;
  final String encoding;
  final String mimetype;
  final String path;
  final int size;
  final String filename;

  Audio({
    required this.fieldname,
    required this.originalname,
    required this.encoding,
    required this.mimetype,
    required this.path,
    required this.size,
    required this.filename,
  });

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      fieldname: json['fieldname'],
      originalname: json['originalname'],
      encoding: json['encoding'],
      mimetype: json['mimetype'],
      path: json['path'],
      size: json['size'],
      filename: json['filename'],
    );
  }
}
