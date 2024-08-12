class QuizQuestions {
  QuizQuestions({
    required this.question,
    required this.options,
    required this.answer,
  });

  final String question;
  final List<String> options;
  final String answer;

  factory QuizQuestions.fromJson(Map<String, dynamic> json) {
    return QuizQuestions(
      question: json['question'],
      options: List<String>.from(json['options'] as List<dynamic>),
      answer: json['answer'],
    );
  }
}
