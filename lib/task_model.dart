class Task {
  final int? id;
  final String title;
  final String desc;
  final bool completed;

  Task({
    this.id,
    required this.title,
    required this.desc,
    required this.completed,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      desc: json['description'],
      completed: json['completed'],
    );
  }
}
