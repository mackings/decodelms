// class CourseDetailResponse {
//   final String message;
//   final List<CourseModuleResponse> result;
//   final List<CommentResponse> comments;

//   CourseDetailResponse({
//     required this.message,
//     required this.result,
//     required this.comments,
//   });

//   factory CourseDetailResponse.fromJson(Map<String, dynamic> json) {
//     final List<dynamic> resultData = json['result'];
//     final List<dynamic> commentData = json['comments'];
//     final List<CourseModuleResponse> result = resultData
//         .map((moduleData) => CourseModuleResponse.fromJson(moduleData))
//         .toList();
//     final List<CommentResponse> comments =
//         commentData.map((comment) => CommentResponse.fromJson(comment)).toList();

//     return CourseDetailResponse(
//       message: json['message'],
//       result: result,
//       comments: comments,
//     );
//   }
// }

// class CourseModuleResponse {
//   final String id;
//   final String userId;
//   final String courseId;
//   final String moduleTitle;
//   final String moduleDescription;
//   final List<VideoResponse> video;
//   final List<ImageResponse> image;
//   final List<ImageResponse> audio;
//   final List<QuestionResponse> questions;
//   final List<dynamic> comments; // This might need to be updated based on actual data

//   CourseModuleResponse({
//     required this.id,
//     required this.userId,
//     required this.courseId,
//     required this.moduleTitle,
//     required this.moduleDescription,
//     required this.video,
//     required this.image,
//     required this.audio,
//     required this.questions,
//     required this.comments,
//   });

//   factory CourseModuleResponse.fromJson(Map<String, dynamic> json) {
//     final List<dynamic> videoData = json['video'];
//     final List<VideoResponse> video =
//         videoData.map((video) => VideoResponse.fromJson(video)).toList();

//     final List<dynamic> imageData = json['image'];
//     final List<ImageResponse> image =
//         imageData.map((image) => ImageResponse.fromJson(image)).toList();

//     final List<dynamic> audioData = json['audio'];
//     final List<ImageResponse> audio =
//         audioData.map((audio) => ImageResponse.fromJson(audio)).toList();

//     final List<dynamic> questionData = json['questions'];
//     final List<QuestionResponse> questions =
//         questionData.map((question) => QuestionResponse.fromJson(question)).toList();

//     return CourseModuleResponse(
//       id: json['_id'],
//       userId: json['userId'],
//       courseId: json['courseId'],
//       moduleTitle: json['module_title'],
//       moduleDescription: json['module_description'],
//       video: video,
//       image: image,
//       audio: audio,
//       questions: questions,
//       comments: json['comments'],
//     );
//   }
// }

// class VideoResponse {
//   final String fieldName;
//   final String originalName;
//   final String encoding;
//   final String mimeType;
//   final String path;
//   final int size;
//   final String filename;

//   VideoResponse({
//     required this.fieldName,
//     required this.originalName,
//     required this.encoding,
//     required this.mimeType,
//     required this.path,
//     required this.size,
//     required this.filename,
//   });

//   factory VideoResponse.fromJson(Map<String, dynamic> json) {
//     return VideoResponse(
//       fieldName: json['fieldname'],
//       originalName: json['originalname'],
//       encoding: json['encoding'],
//       mimeType: json['mimetype'],
//       path: json['path'],
//       size: json['size'],
//       filename: json['filename'],
//     );
//   }
// }

// class ImageResponse {
//   final String fieldName;
//   final String originalName;
//   final String encoding;
//   final String mimeType;
//   final String path;
//   final int size;
//   final String filename;

//   ImageResponse({
//     required this.fieldName,
//     required this.originalName,
//     required this.encoding,
//     required this.mimeType,
//     required this.path,
//     required this.size,
//     required this.filename,
//   });

//   factory ImageResponse.fromJson(Map<String, dynamic> json) {
//     return ImageResponse(
//       fieldName: json['fieldname'],
//       originalName: json['originalname'],
//       encoding: json['encoding'],
//       mimeType: json['mimetype'],
//       path: json['path'],
//       size: json['size'],
//       filename: json['filename'],
//     );
//   }
// }

// class QuestionResponse {
//   final List<dynamic> options; // This might need to be updated based on actual data
//   final String id;
//   final String createdAt;
//   final String updatedAt;

//   QuestionResponse({
//     required this.options,
//     required this.id,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory QuestionResponse.fromJson(Map<String, dynamic> json) {
//     return QuestionResponse(
//       options: json['options'],
//       id: json['_id'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//     );
//   }
// }

// class CommentResponse {
//   final String commentBody;
//   final String moduleId;
//   final String commentBy;
//   final List<dynamic> commentReplies;
//   final List<dynamic> likeBy;
//   final List<dynamic> dislikeBy;
//   final int likeCount;
//   final int dislikeCount;
//   final int replyCount;
//   final bool edited;
//   final String id;
//   final String createdAt;
//   final String updatedAt;

//   CommentResponse({
//     required this.commentBody,
//     required this.moduleId,
//     required this.commentBy,
//     required this.commentReplies,
//     required this.likeBy,
//     required this.dislikeBy,
//     required this.likeCount,
//     required this.dislikeCount,
//     required this.replyCount,
//     required this.edited,
//     required this.id,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory CommentResponse.fromJson(Map<String, dynamic> json) {
//     return CommentResponse(
//       commentBody: json['commentBody'],
//       moduleId: json['moduleId'],
//       commentBy: json['commentBy'],
//       commentReplies: json['commentReplies'],
//       likeBy: json['likeBy'],
//       dislikeBy: json['dislikeBy'],
//       likeCount: json['like_count'],
//       dislikeCount: json['dislike_count'],
//       replyCount: json['reply_count'],
//       edited: json['edited'],
//       id: json['_id'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//     );
//   }
// }





class CourseDetailResponse {
  final String message;
  final List<CourseModule> result;

  CourseDetailResponse({
    required this.message,
    required this.result,
  });

  factory CourseDetailResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> resultData = json['result'];
    final List<CourseModule> result = resultData
        .map((moduleData) => CourseModule.fromJson(moduleData))
        .toList();

    return CourseDetailResponse(
      message: json['message'],
      result: result,
    );
  }
}

class CourseModule {
  final String id;
  final String userId;
  final String courseId;
  final String moduleTitle;
  final String moduleDescription;
  final List<Video> video;
  final List<Image> image;
  final List<Image> audio;
  final String moduleDuration;
  final List<String> quizzes;
  final List<Comment> comments;
  final List<Question> questions;
  final List<String> likeAndDislikeUsers;
  final int commentCount;
  final List<String> commentId;
  final int likeCount;
  final int dislikeCount;
  final String createdAt;
  final String updatedAt;

  CourseModule({
    required this.id,
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
    required this.questions,
    required this.likeAndDislikeUsers,
    required this.commentCount,
    required this.commentId,
    required this.likeCount,
    required this.dislikeCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    final List<dynamic> videoData = json['video'];
    final List<Video> video =
        videoData.map((video) => Video.fromJson(video)).toList();

    final List<dynamic> imageData = json['image'];
    final List<Image> image =
        imageData.map((image) => Image.fromJson(image)).toList();

    final List<dynamic> audioData = json['audio'];
    final List<Image> audio =
        audioData.map((audio) => Image.fromJson(audio)).toList();

    final List<dynamic> questionData = json['questions'];
    final List<Question> questions =
        questionData.map((question) => Question.fromJson(question)).toList();

    final List<dynamic> commentData = json['comments'];
    final List<Comment> comments =
        commentData.map((comment) => Comment.fromJson(comment)).toList();

    return CourseModule(
      id: json['_id'],
      userId: json['userId'],
      courseId: json['courseId'],
      moduleTitle: json['module_title'],
      moduleDescription: json['module_description'],
      video: video,
      image: image,
      audio: audio,
      moduleDuration: json['module_duration'],
      quizzes: (json['quizzes'] as List<dynamic>).cast<String>(),
      comments: comments,
      questions: questions,
      likeAndDislikeUsers: (json['likeAndDislikeUsers'] as List<dynamic>)
          .cast<String>(),
      commentCount: json['comment_count'],
      commentId: (json['commentId'] as List<dynamic>).cast<String>(),
      likeCount: json['like_count'],
      dislikeCount: json['dislike_count'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
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

class Question {
  final String id;
  final List<Answer> answers;
  final String createdAt;
  final String updatedAt;

  Question({
    required this.id,
    required this.answers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final List<dynamic> answersData = json['answers'];
    final List<Answer> answers =
        answersData.map((answer) => Answer.fromJson(answer)).toList();

    return Question(
      id: json['_id'],
      answers: answers,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Answer {
  final String id;
  final String answerText;
  final bool isCorrect;
  final String createdAt;
  final String updatedAt;

  Answer({
    required this.id,
    required this.answerText,
    required this.isCorrect,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['_id'],
      answerText: json['answerText'],
      isCorrect: json['isCorrect'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}


class Comment {
  final String commentBody;
  final String moduleId;
  final String commentBy;
  final List<String> commentReplies;
  final List<String> likeBy;
  final List<String> dislikeBy;
  final int likeCount;
  final int dislikeCount;
  final int replyCount;
  final bool edited;
  final String id;
  final String createdAt;
  final String updatedAt;

  Comment({
    required this.commentBody,
    required this.moduleId,
    required this.commentBy,
    required this.commentReplies,
    required this.likeBy,
    required this.dislikeBy,
    required this.likeCount,
    required this.dislikeCount,
    required this.replyCount,
    required this.edited,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final List<dynamic> commentRepliesData = json['commentReplies'];
    final List<String> commentReplies =
        commentRepliesData.map((reply) => reply.toString()).toList();

    final List<dynamic> likeByData = json['likeBy'];
    final List<String> likeBy = likeByData.map((like) => like.toString()).toList();

    final List<dynamic> dislikeByData = json['dislikeBy'];
    final List<String> dislikeBy =
        dislikeByData.map((dislike) => dislike.toString()).toList();

    return Comment(
      commentBody: json['commentBody'],
      moduleId: json['moduleId'],
      commentBy: json['commentBy'],
      commentReplies: commentReplies,
      likeBy: likeBy,
      dislikeBy: dislikeBy,
      likeCount: json['likeCount'],
      dislikeCount: json['dislikeCount'],
      replyCount: json['replyCount'],
      edited: json['edited'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
