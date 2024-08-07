class Todo {
  int? id;
  String title;
  String description;
  String dueTime;
  String priority;
  String status;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.dueTime,
    required this.priority,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueTime': dueTime,
      'priority': priority,
      'status': status,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueTime: map['dueTime'],
      priority: map['priority'],
      status: map['status'],
    );
  }
}
