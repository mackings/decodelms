class QuizSubmission {
  final List<QuizAnswer> answers;

  QuizSubmission({required this.answers});

  Map<String, dynamic> toJson() {
    return {
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}

class QuizAnswer {
  final String questionId;
  final int selectedAnswerIndex;

  QuizAnswer({required this.questionId, required this.selectedAnswerIndex});

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selected_answer_index': selectedAnswerIndex,
    };
  }
}
