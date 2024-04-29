import 'package:flashcard_quiz/data/models/collection.dart';
import 'package:flashcard_quiz/logic/collections_provider.dart';
import 'package:flashcard_quiz/logic/quiz_provider.dart';
import 'package:flashcard_quiz/presentation/widgets/add_question.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/flashcard.dart';
import '../widgets/results.dart';

int numberOfCorrectAnswers = 0;

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen(
      {super.key, required this.collectionIndex, required this.collection});
  final int collectionIndex;
  final Collection collection;
  @override
  ConsumerState<QuizScreen> createState() {
    return _QuizScreen();
  }
}

class _QuizScreen extends ConsumerState<QuizScreen> {
  late Future<void> _collectionData;

  @override
  void initState() {
    super.initState();
    /*for (final col in dummyData) {
      if (col.title == widget.collection.title) {
        for (int i = 0; i < col.questions.length; i++) {
          ref.read(collectionsProvider.notifier).addNewQA(
                index: widget.collectionIndex,
                question: col.questions[i].question,
                answer: col.questions[i].answer,
              );
        }
      }
    }*/
    _collectionData = ref
        .read(collectionsProvider.notifier)
        .loadCollectionsData(widget.collection);
  }

  @override
  Widget build(BuildContext context) {
    final collection = ref.watch(collectionsProvider)[widget.collectionIndex];
    final questionIndex = ref.watch(quizProvider).index;
    final isQuizFinished = ref.watch(quizProvider).quizFinished;
    final numberOfTotal = collection.questions.length;
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (ctx) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: AddQuestion(
                    collection: collection,
                    collectionIndex: widget.collectionIndex,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
        title: Text(
          collection.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _collectionData,
        builder: (context, snapshot) {
          collection.questions.shuffle();
          if (collection.questions.isEmpty) {
            return Center(
              child: Text(
                'No questions added yet',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            );
          }
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: isQuizFinished
                          ? Results(
                              numberOfTotalAnswers: numberOfTotal,
                              numberOfCorrectAnswers: numberOfCorrectAnswers,
                            )
                          : Column(
                              children: [
                                Center(
                                  child: Text(
                                    '${questionIndex + 1} / ${collection.questions.length}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 22,
                                ),
                                FlashCard(
                                  question: collection
                                      .questions[questionIndex].question,
                                  answer: collection
                                      .questions[questionIndex].answer,
                                  collection: collection,
                                  cardKey: cardKey,
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    isQuizFinished
                        ? TextButton.icon(
                            onPressed: () {
                              ref.read(quizProvider.notifier).reset();
                              numberOfCorrectAnswers = 0;
                            },
                            icon: const Icon(Icons.restore_outlined),
                            label: Text(
                              'Retry',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  ref.read(quizProvider.notifier).quizTraverse(
                                        collection: collection,
                                      );
                                  if (cardKey.currentState!.isFront) {
                                    cardKey.currentState!.toggleCard();
                                  }
                                },
                                icon: const Icon(
                                  Icons.thumb_down,
                                  color: Colors.red,
                                ),
                                label: const Text('Wrong'),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  ref.read(quizProvider.notifier).quizTraverse(
                                        collection: collection,
                                      );
                                  numberOfCorrectAnswers++;
                                  if (cardKey.currentState!.isFront) {
                                    cardKey.currentState!.toggleCard();
                                  }
                                },
                                icon: const Icon(
                                  Icons.thumb_up,
                                  color: Colors.green,
                                ),
                                label: const Text('Right'),
                              ),
                            ],
                          )
                  ],
                );
        },
      ),
    );
  }
}
