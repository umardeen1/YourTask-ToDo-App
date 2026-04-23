import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/controller/todo_controller.dart';
import 'package:to_do_app/view/edit_todo_screen.dart';
import 'package:to_do_app/view/widgets/todo_card.dart';

class TodoListScreen extends StatelessWidget {
  final TodoController controller = Get.put(TodoController());

  TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.todos.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.todos.isEmpty) {
          return const Center(
            child: Text(
              'No todos yet.\nTap + to add one!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.todos.length,
          itemBuilder: (context, index) {
            final todo = controller.todos[index];
            return TodoCard(todo: todo, controller: controller);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddEditTodoScreen()),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
