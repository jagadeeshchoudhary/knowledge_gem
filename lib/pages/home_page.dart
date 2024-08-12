import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:knowledge_gem/models/models.dart';
import 'package:knowledge_gem/pages/pages.dart';

const kAPIKEY = String.fromEnvironment("API_KEY");
const String kFormat =
    '[{"question": "What is the UPSC?", "options": ["A. The United States Postal Service", "B. The Union Public Service Commission", "C. The University of Pennsylvania", "D. The United Nations Security Council"], "answer": "B"}, ...]';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedValue = 5;
  final TextEditingController _questionsController = TextEditingController();
  late GenerativeModel model;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: kAPIKEY,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _questionsController.dispose();
  }

  void _response(prompt) async {
    if (_questionsController.text.trim().isEmpty) {
      showAdaptiveDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog.adaptive(
              title: const Text('Invalid Test name'),
              content: const Text(
                'Data entered on the test field is incorrect or empty. Please enter correct data',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Okay'),
                ),
              ],
            );
          });
    } else {
      try {
        setState(() {
          _isLoading = true;
        });
        final response = await model.generateContent([Content.text(prompt)]);

        final List<dynamic> jsonData = jsonDecode(response.text ?? '');
        final questions = jsonData
            .map((json) => QuizQuestions.fromJson(json as Map<String, dynamic>))
            .toList();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuizPage(
              questions: questions,
              title: _questionsController.text,
            ),
          ),
        );
      } catch (e) {
        showAdaptiveDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog.adaptive(
                title: const Text('Something Wrong'),
                content: const Text(
                  'Sorry but the apps seems broken, It may be Gemini not working or Problem with internet or something else.',
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Okay')),
                ],
              );
            });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (size.width > 600)
                    _buildLargeScreens()
                  else ...[_input(), _dropDown()],
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: ElevatedButton(
                      onPressed: () => _response(
                        'Give $_selectedValue ${_questionsController.text} questions and options with answers in json with format $kFormat and different data on each time',
                      ),
                      child: const Text('Take Test'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLargeScreens() {
    return Row(
      children: [
        Expanded(
          child: _input(),
        ),
        _dropDown(),
      ],
    );
  }

  Widget _input() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: TextField(
        controller: _questionsController,
        decoration: const InputDecoration(
          labelText: 'Enter topic for a test. Example: UPSC or Marvel',
        ),
        keyboardType: TextInputType.text,
        maxLength: 20,
      ),
    );
  }

  Widget _dropDown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: DropdownButton(
        value: _selectedValue,
        items: const [
          DropdownMenuItem(
            value: 5,
            child: Text('5'),
          ),
          DropdownMenuItem(
            value: 10,
            child: Text('10'),
          ),
          DropdownMenuItem(
            value: 20,
            child: Text('20'),
          ),
          DropdownMenuItem(
            value: 30,
            child: Text('30'),
          ),
          DropdownMenuItem(
            value: 50,
            child: Text('50'),
          ),
          DropdownMenuItem(
            value: 100,
            child: Text('100'),
          ),
        ],
        onChanged: (value) {
          if (value == null) {
            return;
          } else {
            setState(() {
              _selectedValue = value;
            });
          }
        },
      ),
    );
  }
}
