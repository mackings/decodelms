class Quiz {
  final String id;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.questions,
  });

factory Quiz.fromJson(Map<String, dynamic> json) {
  final List<dynamic> questionsData = json['quiz']['questions'] ?? [];
  final List<Question> questions = questionsData
      .map((questionData) => Question.fromJson(questionData))
      .toList();

  return Quiz(
    id: json['quiz']['_id'],
    questions: questions,
  );
}

  }


class Question {
  final String id;
  final String questionDescription;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.id,
    required this.questionDescription,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'],
      questionDescription: json['question_description'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correct_answer_index'],
    );
  }
}
