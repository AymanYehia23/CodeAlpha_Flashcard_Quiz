import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Collection {
  Collection({
    String? id,
    required this.title,
    required this.questions,
  }) : id = id ?? uuid.v4();
  final String id;
  final String title;
  List<Question> questions;
}

class Question {
  Question({required this.question, required this.answer});
  final String question;
  final String answer;
}
