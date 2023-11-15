class QuizResponse {
  final String message;
  final Quiz quiz;

  QuizResponse({
    required this.message,
    required this.quiz,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      message: json['message'],
      quiz: Quiz.fromJson(json['quiz']),
    );
  }
}

class Quiz {
  final String id;
  final String moduleId;
  final List<String> questionIds;
  final List<Question> questions;
  final String createdAt;
  final String updatedAt;
  final int v;

  Quiz({
    required this.id,
    required this.moduleId,
    required this.questionIds,
    required this.questions,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final List<dynamic> questionIdsData = json['questionIds'];
    final List<String> questionIds = List<String>.from(questionIdsData);

    final List<dynamic> questionsData = json['questions'];
    final List<Question> questions = questionsData.map((questionData) => Question.fromJson(questionData)).toList();

    return Quiz(
      id: json['_id'],
      moduleId: json['moduleId'],
      questionIds: questionIds,
      questions: questions,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}

class Question {
  final String moduleId;
  final String title;
  final String description;
  final String duration;
  final List<String> answers;
  final int correctAnswerIndex;
  final String id;
  final String createdAt;
  final String updatedAt;

  Question({
    required this.moduleId,
    required this.title,
    required this.description,
    required this.duration,
    required this.answers,
    required this.correctAnswerIndex,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      moduleId: json['moduleId'],
      title: json['question_title'] ?? '',
      description: json['question_description'] ?? '',
      duration: json['question_duration'] ?? '',
      answers: List<String>.from(json['answers']),
      correctAnswerIndex: json['correctAnswerIndexes'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
