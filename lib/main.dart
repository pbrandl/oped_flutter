import 'package:flutter/material.dart';
import 'package:oped/edit_task_page.dart';
import 'package:oped/api_service.dart';
import 'package:oped/task_model.dart';

void main() {
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oped Task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TaskPage(title: 'Task Page'),
    );
  }
}

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, required this.title});

  final String title;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    updateTasks();
  }

  updateTasks() {
    setState(() {
      futureTasks = ApiService().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: tasksFuture(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditTaskPage(),
            ),
          ).then(
            (_) => updateTasks(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget tasksFuture() => FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No Tasks Found!'));
          } else {
            return Expanded(
              child: SizedBox(
                width: 500,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditTaskPage(task: snapshot.data![index]),
                        ),
                      ).then(
                        (_) => updateTasks(),
                      ),
                      title: Text(snapshot.data![index].title),
                      subtitle: Text(snapshot.data![index].desc),
                      trailing: Checkbox(
                        value: snapshot.data![index].completed,
                        onChanged: (bool? value) {
                          // Handle task completion toggle
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      );
}
