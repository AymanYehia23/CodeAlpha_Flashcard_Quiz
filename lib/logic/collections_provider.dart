import 'package:flashcard_quiz/data/models/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getCollectionsDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'collections.db'),
    version: 1,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_collections(id TEXT PRIMARY KEY, title TEXT)',
      );
    },
  );
  return db;
}

Future<Database> _getCollectionsData() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'collectionsData.db'),
    version: 1,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_collections_data(title TEXT, question Text, answer Text)',
      );
    },
  );
  return db;
}

class CollectionsNotifier extends StateNotifier<List<Collection>> {
  CollectionsNotifier() : super(const []);

  Future<void> loadCollections() async {
    final db = await _getCollectionsDatabase();
    final data = await db.query('user_collections');
    final collections = data
        .map(
          (row) => Collection(
            id: row['id'] as String,
            title: row['title'] as String,
            questions: [],
          ),
        )
        .toList();
    state = collections;
  }

  Future<void> loadCollectionsData(Collection collection) async {
    final db = await _getCollectionsData();
    final bool isEmpty = await db.query('user_collections_data') == [];
    if (isEmpty) {
      return;
    }
    final data = await db.query(
      'user_collections_data',
      where: 'title = ?',
      whereArgs: [collection.title],
    );
    collection.questions = [];
    data.map((row) {
      collection.questions.add(Question(
          question: row['question'] as String,
          answer: row['answer'] as String));
    }).toList();
  }

  void addNewCollection(String title) async {
    final Collection collection = Collection(
      title: title,
      questions: [],
    );
    final db = await _getCollectionsDatabase();
    db.insert(
      'user_collections',
      {
        'id': collection.id,
        'title': collection.title,
      },
    );
    state = [
      ...state,
      collection,
    ];
  }

  void deleteCollection(Collection collection) async {
    state.remove(collection);
    final db = await _getCollectionsDatabase();
    await db.delete(
      'user_collections',
      where: 'id = ?',
      whereArgs: [collection.id],
    );
    final dbs = await _getCollectionsData();
    await dbs.delete(
      'user_collections_data',
      where: 'title = ?',
      whereArgs: [collection.title],
    );
    state = [...state];
  }

  void addNewQA(
      {required int index,
      required String question,
      required String answer}) async {
    final db = await _getCollectionsData();
    await db.insert(
      'user_collections_data',
      {
        'title': state[index].title,
        'question': question,
        'answer': answer,
      },
    );
    state[index].questions.add(Question(question: question, answer: answer));
    state = [...state];
  }

  void deleteQA({
    required String question,
    required String answer,
    required Collection collection,
  }) async {
    final dbs = await _getCollectionsData();
    await dbs.delete(
      'user_collections_data',
      where: 'question = ?',
      whereArgs: [question],
    );
    collection.questions.remove(Question(question: question, answer: answer));
    state = [...state];
  }
}

final collectionsProvider =
    StateNotifierProvider<CollectionsNotifier, List<Collection>>((ref) {
  return CollectionsNotifier();
});
