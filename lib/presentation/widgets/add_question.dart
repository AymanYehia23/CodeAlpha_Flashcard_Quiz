import 'package:flashcard_quiz/logic/collections_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/collection.dart';

class AddQuestion extends ConsumerWidget {
  const AddQuestion(
      {super.key,required this.collectionIndex, required this.collection});
  final Collection collection;
  final int collectionIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController questionController = TextEditingController();
    final TextEditingController answerController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter New Question',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          const SizedBox(
            height: 12,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Question'),
            controller: questionController,
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
          const SizedBox(
            height: 12,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Answer'),
            controller: answerController,
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
           const SizedBox(
            height: 22,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(collectionsProvider.notifier).addNewQA(
                    index: collectionIndex,
                        question: questionController.text,
                        answer: answerController.text,
                      );
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Add question',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
