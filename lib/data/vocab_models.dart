import 'package:flutter/material.dart';

class VocabWord {
  final String word;
  final String phonetic;
  final String meaning;
  final String example;
  final String exampleMeaning;

  const VocabWord({
    required this.word,
    required this.phonetic,
    required this.meaning,
    required this.example,
    required this.exampleMeaning,
  });
}

class VocabTopic {
  final String name;
  final IconData icon;
  final Color color;
  final List<VocabWord> words;

  const VocabTopic({
    required this.name,
    required this.icon,
    required this.color,
    required this.words,
  });
}
