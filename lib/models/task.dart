class Task {
  int id;
  String title;
  DateTime date;
  int status;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['date'] = date.toIso8601String();
    map['status'] = status;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      status: map['status'],
    );
  }
}
