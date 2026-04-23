import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/storage/app_database.dart';
import 'package:to_do_app/model/todo_model.dart';

class TodoController extends GetxController {
  final AppDatabase database = AppDatabase();

  var todos = <TodoModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    try {
      isLoading.value = true;
      final dbTodos = await database.getAllTodos();
      todos.value = dbTodos
          .map((todo) => TodoModel.fromDatabase(todo))
          .toList();
    } catch (e) {
      _showSnackbar('Error', 'Failed to load todos', Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTodo(TodoModel todo) async {
    try {
      isLoading.value = true;
      final id = await database.insertTodo(todo.toCompanion());
      final newTodo = TodoModel(
        id: id,
        title: todo.title,
        description: todo.description,
        color: todo.color,
        createdAt: todo.createdAt,
      );
      todos.insert(0, newTodo);
      Get.back();
      _showSnackbar('Success', 'Todo added successfully', Colors.green);
    } catch (e) {
      _showSnackbar('Error', 'Failed to add todo', Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTodo(TodoModel todo) async {
    try {
      isLoading.value = true;
      await database.updateTodo(
        Todo(
          id: todo.id,
          title: todo.title,
          description: todo.description,
          color: todo.color,
          createdAt: todo.createdAt,
        ),
      );

      final index = todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        todos[index] = todo;
      }
      Get.back();
      _showSnackbar('Success', 'Todo updated successfully', Colors.green);
    } catch (e) {
      _showSnackbar('Error', 'Failed to update todo', Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      final result = await Get.defaultDialog<bool>(
        title: 'Delete Todo',
        middleText: 'Are you sure you want to delete this todo?',
        textConfirm: 'Delete',
        textCancel: 'Cancel',
        confirmTextColor: Colors.white,
        onConfirm: () => Get.back(result: true),
        onCancel: () => Get.back(result: false),
      );

      if (result == true) {
        isLoading.value = true;
        await database.deleteTodo(id);
        todos.removeWhere((todo) => todo.id == id);
        _showSnackbar('Deleted', 'Todo deleted successfully', Colors.red);
      }
    } catch (e) {
      _showSnackbar('Error', 'Failed to delete todo', Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void _showSnackbar(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      colorText: Colors.white,
    );
  }
}
