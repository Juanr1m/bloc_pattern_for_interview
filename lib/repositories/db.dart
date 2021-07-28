import 'package:agrobank_test/repositories/models/task.dart';
import 'package:hive/hive.dart';

import 'dart:async';

class TaskDatabase {
  String _boxName = 'Task';
  // open a box
  Future<Box> taskBox() async {
    var box = await Hive.openBox<Task>(_boxName);
    return box;
  }

  // get full tasks
  Future<List<Task>> getFullTasks() async {
    final box = await taskBox();
    List<Task> tasks = box.values.toList() as List<Task>;
    return tasks;
  }

  // to add data in box
  Future<void> addToBox(Task task) async {
    final box = await taskBox();

    await box.add(task);
  }

  // delete data from box
  Future<void> deleteFromBox(int index) async {
    final box = await taskBox();
    await box.deleteAt(index);
  }

  // delete all data from box
  Future<void> deleteAll() async {
    final box = await taskBox();
    await box.clear();
  }

  // update data
  Future<void> updateTask(int? index, Task task) async {
    final box = await taskBox();
    await box.putAt(index!, task);
  }
}
