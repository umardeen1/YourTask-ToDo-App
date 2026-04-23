import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/controller/todo_controller.dart';
import 'package:to_do_app/model/todo_model.dart';
import 'package:to_do_app/view/edit_todo_screen.dart';

class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final TodoController controller;

  const TodoCard({super.key, required this.todo, required this.controller});

  String _formatCreatedAt(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.deleteTodo(todo.id),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _parseColor(todo.color),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Get.to(() => AddEditTodoScreen(todo: todo)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: _getTextColor(todo.color),
                          ),
                        ),
                        if (todo.description != null &&
                            todo.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              todo.description!,
                              style: TextStyle(
                                color: _getTextColor(
                                  todo.color,
                                ).withValues(alpha: 0.8),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _formatCreatedAt(todo.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          Icons.edit,
                          color: _getTextColor(todo.color),
                        ),
                        onPressed: () =>
                            Get.to(() => AddEditTodoScreen(todo: todo)),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          Icons.delete_outline,
                          color: _getTextColor(todo.color),
                        ),
                        onPressed: () => controller.deleteTodo(todo.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString, radix: 16));
    } catch (e) {
      return Colors.blue;
    }
  }

  Color _getTextColor(String colorString) {
    final color = _parseColor(colorString);
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
