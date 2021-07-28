import 'package:hive/hive.dart';
part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final DateTime date;
  @HiveField(3)
  final String status;

  Task({
    required this.title,
    required this.date,
    required this.status,
  });
}
