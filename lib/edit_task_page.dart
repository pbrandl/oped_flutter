import 'package:flutter/material.dart';
import 'package:oped/task_model.dart';
import 'package:oped/api_service.dart';

class EditTaskPage extends StatefulWidget {
  final Task? task;

  const EditTaskPage({
    super.key,
    this.task,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  bool widgetLocked = false;
  lockWidget() => widgetLocked = true;
  unlockWidget() => widgetLocked = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late bool _completed;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(text: widget.task?.desc ?? '');
    _completed = widget.task?.completed ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveTask() async {
    lockWidget();

    if (_formKey.currentState!.validate()) {
      if (widget.task == null) {
        Task newTask = Task(
          title: _titleController.text,
          desc: _descController.text,
          completed: _completed,
        );
        await ApiService().createTask(newTask);
      } else {
        Task editTask = Task(
          id: widget.task!.id,
          title: _titleController.text,
          desc: _descController.text,
          completed: _completed,
        );

        await ApiService().editTask(editTask);
      }
    }
    Navigator.pop(context);
    unlockWidget();
  }

  void _deleteTask() async {
    lockWidget();

    await ApiService().deleteTask(widget.task!.id!);
    Navigator.pop(context);
    unlockWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Edit Task'),
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                CheckboxListTile(
                  title: const Text('Completed'),
                  value: _completed,
                  onChanged: (bool? value) {
                    setState(() {
                      _completed = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveTask,
                  child: widgetLocked
                      ? const CircularProgressIndicator()
                      : const Text('Save Task'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: widget.task == null ? null : _deleteTask,
                  child: widgetLocked
                      ? const CircularProgressIndicator()
                      : const Text('Delete Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
