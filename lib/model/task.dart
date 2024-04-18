class Task {
  String task;
  String description;
  DateTime time;

  Task({required this.task, required this.time, required this.description});

  factory Task.fromString(String task, String description) {
    return Task(
      task: task,
      description: description,
      time: DateTime.now(),
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      task: map['task'],
      description: map['description'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  Map<String, dynamic> getMap(){
    return {
      'task': task,
      'description': description,
      'time': time.millisecondsSinceEpoch,
    };
  }


}
