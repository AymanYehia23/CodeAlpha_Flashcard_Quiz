import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/collection.dart';
import '../data/models/quiz.dart';

class QuizNotifier extends StateNotifier<Quiz> {
  QuizNotifier() : super(Quiz());

  
  void reset() {
    state = Quiz();
  }

  void quizTraverse({required Collection collection}) {
    if (state.index == collection.questions.length - 1) {
      state = Quiz(
        quizFinished: true,
      );
      return;
    }
    state = Quiz(
      index: state.index + 1,
    );
  }
}

final quizProvider = StateNotifierProvider<QuizNotifier, Quiz>((ref) {
  return QuizNotifier();
});
