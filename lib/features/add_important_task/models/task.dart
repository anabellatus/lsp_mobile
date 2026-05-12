class Task {
  final int? id;
  final String username;
  final String title;
  final String description;
  final String dueDate;
  final String taskType;
  final String status;
  final DateTime createdAt;

  Task({
    this.id,
    required this.username,
    required this.title,
    required this.description,
    required this.dueDate,
    this.taskType = 'PENTING',
    this.status = 'pending',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'taskType': taskType,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      username: map['username'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      dueDate: map['dueDate'] as String,
      taskType: map['taskType'] as String? ?? 'PENTING',
      status: map['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
