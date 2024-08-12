import 'package:flutter/material.dart';

import 'package:knowledge_gem/models/models.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({
    super.key,
    required this.questions,
    required this.title,
  });

  final List<QuizQuestions> questions;
  final String title;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Map<int, int?> selectedOptionIndexs = {};
  Map<int, bool> isCorrect = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.title.toUpperCase()} QUIZ')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < widget.questions.length; i++)
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text('${i + 1}. ${widget.questions[i].question}'),
                    ),
                    for (int j = 0; j < widget.questions[i].options.length; j++)
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: TextButton(
                          onPressed: selectedOptionIndexs[i] == null
                              ? () {
                                  setState(() {
                                    selectedOptionIndexs[i] = j;
                                    isCorrect[i] = widget
                                            .questions[i].options[j]
                                            .substring(0, 1) ==
                                        widget.questions[i].answer;
                                  });
                                }
                              : null,
                          style: TextButton.styleFrom(
                            backgroundColor: selectedOptionIndexs[i] == j
                                ? (isCorrect[i]! ? Colors.green : Colors.red)
                                : null,
                          ),
                          child: Text(widget.questions[i].options[j]),
                        ),
                      ),
                    if (selectedOptionIndexs[i] != null &&
                        isCorrect[i] == false)
                      Container(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          children: [
                            Text(
                              'Correct Answer: ${widget.questions[i].answer}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
