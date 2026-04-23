import 'package:to_do_app/storage/app_database.dart';
import 'package:drift/drift.dart' as drift;

class TodoModel {
  final int id;
  final String title;
  final String? description;
  final String color;
  final DateTime createdAt;

  TodoModel({
    required this.id,
    required this.title,
    this.description,
    required this.color,
    required this.createdAt,
  });

  factory TodoModel.fromDatabase(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      color: todo.color,
      createdAt: todo.createdAt,
    );
  }

  TodosCompanion toCompanion() {
    return TodosCompanion(
      id: id > 0 ? drift.Value(id) : const drift.Value.absent(),
      title: drift.Value(title),
      description: drift.Value(description),
      color: drift.Value(color),
      createdAt: drift.Value(createdAt),
    );
  }
}
