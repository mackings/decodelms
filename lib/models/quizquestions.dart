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
    final List<String> questionIds = questionIdsData.cast<String>();

    final List<dynamic> questionsData = json['questions'];
    final List<Question> questions = questionsData
        .map((questionData) => Question.fromJson(questionData))
        .toList();

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
  final List<Answer> answers;
  final String id;
  final String createdAt;
  final String updatedAt;

  Question({
    required this.moduleId,
    required this.title,
    required this.description,
    required this.duration,
    required this.answers,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final List<dynamic> answersData = json['answers'];
    final List<Answer> answers = answersData
        .map((answerData) => Answer.fromJson(answerData))
        .toList();

    return Question(
      moduleId: json['moduleId'],
      title: json['question_title'] ?? '', // You may want to provide a default value
      description: json['question_description'] ?? '', // You may want to provide a default value
      duration: json['question_duration'] ?? '', // You may want to provide a default value
      answers: answers,
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Answer {
  final String text;
  final bool isCorrect;
  final String id;
  final String createdAt;
  final String updatedAt;

  Answer({
    required this.text,
    required this.isCorrect,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      text: json['text'],
      isCorrect: json['isCorrect'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
