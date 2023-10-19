// class CourseReview {
//   final String review;
//   final int rating;
//   final String userId;
//   final String courseId;
//   final String id;
//   final String createdAt;
//   final String updatedAt;

//   CourseReview({
//     required this.review,
//     required this.rating,
//     required this.userId,
//     required this.courseId,
//     required this.id,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory CourseReview.fromJson(Map<String, dynamic> json) {
//     return CourseReview(
//       review: json['review'],
//       rating: json['rating'],
//       userId: json['userId'],
//       courseId: json['courseId'],
//       id: json['_id'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//     );
//   }
// }

// class CourseModule {
//   final String userId;
//   final String courseId;
//   final String moduleTitle;
//   final String moduleDescription;
//   final String id;
//   final String createdAt;
//   final String updatedAt;

//   final List<String> videoPaths; // List of video paths
//   final List<String> imagePaths; // List of image paths
//   final List<String> audioPaths; // List of audio paths

//   CourseModule({
//     required this.userId,
//     required this.courseId,
//     required this.moduleTitle,
//     required this.moduleDescription,
//     required this.id,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.videoPaths,
//     required this.imagePaths,
//     required this.audioPaths,
//   });

//   factory CourseModule.fromJson(Map<String, dynamic> json) {
//     final videoPaths = (json['video'] as List).map((video) => video['path']).toList();
//     final imagePaths = (json['image'] as List).map((image) => image['path']).toList();
//     final audioPaths = (json['audio'] as List).map((audio) => audio['path']).toList();

//     return CourseModule(
//       userId: json['userId'],
//       courseId: json['courseId'],
//       moduleTitle: json['module_title'],
//       moduleDescription: json['module_description'],
//       id: json['_id'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//       videoPaths: videoPaths,
//       imagePaths: imagePaths,
//       audioPaths: audioPaths,
//     );
//   }
// }

// class Course {
//   final String id;
//   final String userId;
//   final String title;
//   final String description;
//   final String language;
//   final String imageUrl;
//   final String isPaidCourse;
//   final int isPriceCourse;
//   final int totalRegisteredByStudent;
//   final List<String> subjects; // List of subjects
//   final List<CourseModule> modules;
//   final List<CourseReview> reviews;

//   Course({
//     required this.id,
//     required this.userId,
//     required this.title,
//     required this.description,
//     required this.language,
//     required this.imageUrl,
//     required this.isPaidCourse,
//     required this.isPriceCourse,
//     required this.totalRegisteredByStudent,
//     required this.subjects,
//     required this.modules,
//     required this.reviews,
//   });

//   factory Course.fromJson(Map<String, dynamic> json) {
//     final subjects = (json['subjects'] as List).map((subject) => subject.toString()).toList();
//     final modules = (json['modules'] as List).map((module) => CourseModule.fromJson(module)).toList();
//     final reviews = (json['reviews'] as List).map((review) => CourseReview.fromJson(review)).toList();

//     return Course(
//       id: json['_id'],
//       userId: json['userId'],
//       title: json['course_title'],
//       description: json['course_description'],
//       language: json['course_language'],
//       imageUrl: json['course_image'][0]['path'],
//       isPaidCourse: json['isPaid_course'],
//       isPriceCourse: json['isPrice_course'],
//       totalRegisteredByStudent: json['totalRegisteredByStudent'],
//       subjects: subjects,
//       modules: modules,
//       reviews: reviews,
//     );
//   }
// }

// class CourseResponse {
//   final String message;
//   final List<Course> courses;

//   CourseResponse({
//     required this.message,
//     required this.courses,
//   });

//   factory CourseResponse.fromJson(Map<String, dynamic> json) {
//     final courses = (json['course'] as List).map((course) => Course.fromJson(course)).toList();
//     return CourseResponse(
//       message: json['message'],
//       courses: courses,
//     );
//   }
// }
