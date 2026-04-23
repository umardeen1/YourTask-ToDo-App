import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'todo_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertTodo(TodosCompanion todo) {
    return into(todos).insert(todo);
  }

  Future<List<Todo>> getAllTodos() {
    return (select(todos)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  Future<bool> updateTodo(Todo todo) {
    return update(todos).replace(todo);
  }

  Future<int> deleteTodo(int id) {
    return (delete(todos)..where((t) => t.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'todo.sqlite'));
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    return NativeDatabase.createInBackground(file);
  });
}
