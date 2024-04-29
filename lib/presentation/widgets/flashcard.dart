import 'package:flashcard_quiz/data/models/collection.dart';
import 'package:flashcard_quiz/logic/collections_provider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashCard extends ConsumerWidget {
  const FlashCard({
    super.key,
    required this.question,
    required this.answer,
    required this.collection,
    required this.cardKey,
  });
  final String question;
  final String answer;
  final Collection collection;
  final GlobalKey<FlipCardState> cardKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Builder(
          builder: (context) {
            return FlipCard(
              key: cardKey,
              side: CardSide.FRONT,
              direction: FlipDirection.HORIZONTAL,
              front: Container(
                padding: const EdgeInsets.all(12),
                width: 350,
                height: 350,
                color: Colors.amberAccent,
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    question,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
              ),
              back: Container(
                padding: const EdgeInsets.all(12),
                width: 350,
                height: 350,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    answer,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
              ),
            );
          }
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: IconButton(
            icon:  Icon(
              Icons.delete,
              size: 40,
              color: Theme.of(context).colorScheme.errorContainer,
            ),
            onPressed: () {
               ref.read(collectionsProvider.notifier).deleteQA(
                    question: question,
                    answer: answer,
                    collection: collection,
                  );
            },
          ),
        )
      ],
    );
  }
}
