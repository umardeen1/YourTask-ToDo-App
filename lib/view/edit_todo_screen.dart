import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/controller/todo_controller.dart';
import 'package:to_do_app/model/todo_model.dart';

class AddEditTodoScreen extends StatefulWidget {
  final TodoModel? todo;

  const AddEditTodoScreen({super.key, this.todo});

  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Color _selectedColor;
  final TodoController _todoController = Get.find();

  final List<Color> _presetColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.todo?.description ?? '',
    );
    _selectedColor = widget.todo != null
        ? _parseColor(widget.todo!.color)
        : Colors.blue;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString, radix: 16));
    } catch (e) {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Todo' : 'Add Todo'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Description (Optional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Select Card Color',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _presetColors.map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveTodo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(isEditing ? 'Update' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      final todo = TodoModel(
        id: widget.todo?.id ?? 0,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        color: _selectedColor.value.toRadixString(16),
        createdAt: widget.todo?.createdAt ?? DateTime.now(),
      );

      if (widget.todo != null) {
        _todoController.updateTodo(todo);
      } else {
        _todoController.addTodo(todo);
      }
    }
  }
}
