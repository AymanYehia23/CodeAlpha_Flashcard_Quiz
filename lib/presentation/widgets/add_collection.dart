import 'package:flashcard_quiz/logic/collections_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCollection extends ConsumerWidget {
  const AddCollection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController textEditingController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter New Collection',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          const SizedBox(
            height: 12,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Title'),
            maxLength: 50,
            controller: textEditingController,
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
          const SizedBox(
            height: 12,
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
                  ref
                      .read(collectionsProvider.notifier)
                      .addNewCollection(textEditingController.text);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Add collection',
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
