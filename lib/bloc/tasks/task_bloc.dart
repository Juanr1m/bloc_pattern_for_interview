import 'dart:async';

import 'package:agrobank_test/repositories/db.dart';
import 'package:equatable/equatable.dart';

import 'package:bloc/bloc.dart';

import 'package:agrobank_test/repositories/models/task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskDatabase _taskDatabase;
  List<Task> _tasks = [];
  TaskBloc(this._taskDatabase) : super(TaskInitial());

  @override
  Stream<TaskState> mapEventToState(
    TaskEvent event,
  ) async* {
    if (event is TaskInitialEvent) {
      yield* _mapInitialEventToState();
    }

    if (event is TaskAddEvent) {
      yield* _mapNoteAddEventToState(
          title: event.title, date: event.date, status: event.status);
    }

    if (event is TaskEditEvent) {
      yield* _mapNoteEditEventToState(
          title: event.title,
          date: event.date,
          status: event.status,
          index: event.index);
    }

    if (event is TaskDeleteEvent) {
      yield* _mapNoteDeleteEventToState(index: event.index);
    }
  }

  // Stream Functions
  Stream<TaskState> _mapInitialEventToState() async* {
    yield TasksLoading();

    await _getNotes();

    yield AllTasksState(tasks: _tasks);
  }

  Stream<TaskState> _mapNoteAddEventToState(
      {required String title,
      required DateTime date,
      required String status}) async* {
    yield TasksLoading();
    await _addToNotes(title: title, date: date, status: status);
    yield AllTasksState(tasks: _tasks);
  }

  Stream<TaskState> _mapNoteEditEventToState(
      {required String title,
      required DateTime date,
      required String status,
      required int? index}) async* {
    yield TasksLoading();
    await _updateNote(
        newTitle: title, newStatus: status, newDate: date, index: index);
    yield AllTasksState(tasks: _tasks);
  }

  Stream<TaskState> _mapNoteDeleteEventToState({required int index}) async* {
    yield TasksLoading();
    await _removeFromNotes(index: index);
    _tasks.sort((a, b) {
      var aDate = a.title;
      var bDate = b.title;
      return aDate.compareTo(bDate);
    });
    yield AllTasksState(tasks: _tasks);
  }

  // Helper Functions
  Future<void> _getNotes() async {
    await _taskDatabase.getFullTasks().then((value) {
      _tasks = value;
    });
  }

  Future<void> _addToNotes(
      {required String title,
      required DateTime date,
      required String status}) async {
    await _taskDatabase
        .addToBox(Task(title: title, date: date, status: status));
    await _getNotes();
  }

  Future<void> _updateNote(
      {required int? index,
      required String newTitle,
      required DateTime newDate,
      required String newStatus}) async {
    await _taskDatabase.updateTask(
        index, Task(title: newTitle, date: newDate, status: newStatus));
    await _getNotes();
  }

  Future<void> _removeFromNotes({required int index}) async {
    await _taskDatabase.deleteFromBox(index);
    await _getNotes();
  }
}
