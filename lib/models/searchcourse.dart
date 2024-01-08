class CourseResponse {
  final String message;
  final List<Courseresults> courses;

  CourseResponse({
    required this.message,
    required this.courses,
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> coursesData = json['course'];
    final List<Courseresults> courses = coursesData
        .map((courseData) => Courseresults.fromJson(courseData))
        .toList();

    return CourseResponse(
      message: json['message'],
      courses: courses,
    );
  }
}

class Courseresults {
  final String id;
  final String userId;
  final String courseTitle;
  final String courseDescription;
  final String courseLanguage;
  final List<Review> reviews;
  final List<CourseImage> courseImages;
  final String isPaidCourse;
  final int isPriceCourse;
  final int totalRegisteredByStudent;
  final List<Module> modules;
  final String createdAt;
  final String updatedAt;

  Courseresults({
    required this.id,
    required this.userId,
    required this.courseTitle,
    required this.courseDescription,
    required this.courseLanguage,
    required this.reviews,
    required this.courseImages,
    required this.isPaidCourse,
    required this.isPriceCourse,
    required this.totalRegisteredByStudent,
    required this.modules,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Courseresults.fromJson(Map<String, dynamic> json) {
    final List<dynamic> reviewsData = json['reviews'] ?? [];
    final List<Review> reviews = reviewsData
        .map((reviewData) => Review.fromJson(reviewData))
        .toList();

    final List<dynamic> courseImagesData = json['course_image']?? [];
    final List<CourseImage> courseImages = courseImagesData
        .map((courseImageData) => CourseImage.fromJson(courseImageData))
        .toList();

    final List<dynamic> modulesData = json['modules']?? [];
    final List<Module> modules = modulesData
        .map((moduleData) => Module.fromJson(moduleData))
        .toList();

    return Courseresults(
      id: json['_id'],
      userId: json['userId'],
      courseTitle: json['course_title'],
      courseDescription: json['course_description'],
      courseLanguage: json['course_language'],
      reviews: reviews,
      courseImages: courseImages,
      isPaidCourse: json['isPaid_course'],
      isPriceCourse: json['isPrice_course'],
      totalRegisteredByStudent: json['totalRegisteredByStudent'],
      modules: modules,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Review {
  final String id;
  final String userId;
  final String reviewText;
  final int rating;
  final String createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.reviewText,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      userId: json['userId'],
      reviewText: json['reviewText'],
      rating: json['rating'],
      createdAt: json['createdAt'],
    );
  }
}


class CourseImage {
  final String fieldname;
  final String originalname;
  final String encoding;
  final String mimetype;
  final String path;
  final int size;
  final String filename;

  CourseImage({
    required this.fieldname,
    required this.originalname,
    required this.encoding,
    required this.mimetype,
    required this.path,
    required this.size,
    required this.filename,
  });

  factory CourseImage.fromJson(Map<String, dynamic> json) {
    return CourseImage(
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


class Module {
  final String userId;
  final String courseId;
  final String moduleTitle;
  final String moduleDescription;
  final String moduleDuration;
  final List<String> quizzes;
  final List<String> comments;
  final List<String> likeAndDislikeUsers;
  final int commentCount;
  final List<String> commentId;
  final int likeCount;
  final int dislikeCount;
  final String id;
  final String createdAt;
  final String updatedAt;
  final List<String> questions;
  final List<Map<String, String>?> image;
  final List<Map<String, String>?> video;

  Module({
    required this.userId,
    required this.courseId,
    required this.moduleTitle,
    required this.moduleDescription,
    required this.image,
    required this.video,
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
    required this.questions,
  });

factory Module.fromJson(Map<String, dynamic> json) {
  List<Map<String, String>?>? imageList = (json['image'] as List<dynamic>?)
      ?.map((imageJson) {
        if (imageJson is Map<String, String>) {
          return Map<String, String>.from(imageJson);
        } else if (imageJson is String) {
          return {'path': imageJson};
        } else {
          return null;
        }
      })
      .where((image) => image != null)
      .toList();

  List<Map<String, String>?>? videoList = (json['video'] as List<dynamic>?)
      ?.map((videoJson) {
        if (videoJson is Map<String, String>) {
          return Map<String, String>.from(videoJson);
        } else if (videoJson is String) {
          return {'path': videoJson};
        } else {
          return null;
        }
      })
      .where((video) => video != null)
      .toList();

  return Module(
    userId: json['userId'] ?? '',
    courseId: json['courseId'] ?? '',
    moduleTitle: json["module_title"] ?? '',
    moduleDescription: json['module_description'] ?? '',
    image: imageList ?? [],
    video: videoList ?? [],
    moduleDuration: json['moduleDuration'] ?? '',
    quizzes: (json['quizzes'] as List<dynamic>?)
        ?.map((quiz) => quiz.toString())
        .toList() ?? [],
    comments: (json['comments'] as List<dynamic>?)
        ?.map((comment) => comment.toString())
        .toList() ?? [],
    likeAndDislikeUsers: (json['likeAndDislikeUsers'] as List<dynamic>?)
        ?.map((user) => user.toString())
        .toList() ?? [],
    commentCount: json['commentCount'] ?? 0, // Use appropriate defaults
    commentId: (json['commentId'] as List<dynamic>?)
        ?.map((commentId) => commentId.toString())
        .toList() ?? [],
    likeCount: json['likeCount'] ?? 0, // Use appropriate defaults
    dislikeCount: json['dislikeCount'] ?? 0, // Use appropriate defaults
    id: json['_id'] ?? '',
    createdAt: json['createdAt'] ?? '',
    updatedAt: json['updatedAt'] ?? '',
    questions: (json['questions'] as List<dynamic>?)
        ?.map((question) => question.toString())
        .toList() ?? [],
  );
}


}


