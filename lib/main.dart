import 'package:flutter/material.dart';

import 'package:knowledge_gem/pages/pages.dart';

void main() async {
  runApp(
    const KnowledgeGem(),
  );
}

class KnowledgeGem extends StatelessWidget {
  const KnowledgeGem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Knowledge Gem',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 73, 2, 239),
        ),
        appBarTheme: const AppBarTheme().copyWith(
          centerTitle: true,
          foregroundColor: Theme.of(context).primaryColor,
        ),
      ),
      darkTheme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(225, 0, 0, 0),
        ),
      ),
      home: const HomePage(
        title: 'Knowledge Gem',
      ),
    );
  }
}
