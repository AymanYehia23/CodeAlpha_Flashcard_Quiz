import 'package:flutter/material.dart';
import '../widgets/add_collection.dart';
import '../widgets/collections_list.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Collections',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: const CollectionsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: const AddCollection(),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
