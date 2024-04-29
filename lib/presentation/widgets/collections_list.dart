import 'package:flashcard_quiz/logic/collections_provider.dart';
import 'package:flashcard_quiz/presentation/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/quiz_provider.dart';

class CollectionsList extends ConsumerStatefulWidget {
  const CollectionsList({super.key});
  @override
  ConsumerState<CollectionsList> createState() {
    return _CollectionsListState();
  }
}

class _CollectionsListState extends ConsumerState<CollectionsList> {
  late Future<void> _collectionsFuture;
  @override
  void initState() {
    super.initState();
    /*for (final col in dummyData) {
      ref.read(collectionsProvider.notifier).addNewCollection(col.title);
    }*/
    _collectionsFuture =
        ref.read(collectionsProvider.notifier).loadCollections();
  }

  @override
  Widget build(BuildContext context) {
    final collections = ref.watch(collectionsProvider);
    return FutureBuilder(
      future: _collectionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (collections.isEmpty) {
          return Center(
            child: Text(
              'No collections added yet',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          );
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 30),
          itemCount: collections.length,
          itemBuilder: (ctx, index) => Dismissible(
            direction: DismissDirection.startToEnd,
            background: Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.errorContainer,
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
            key: ValueKey(collections[index].id),
            onDismissed: (direction) =>
                ref.read(collectionsProvider.notifier).deleteCollection(
                      collections[index],
                    ),
            child: InkWell(
              onTap: () {
                ref.read(quizProvider.notifier).reset();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => QuizScreen(
                      collectionIndex: index,
                      collection: collections[index],
                    ),
                  ),
                );
              },
              
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(8),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  collections[index].title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
