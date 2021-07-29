part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object> get props => [];
}

// initial
class TaskInitial extends TaskState {}

// loading
class TasksLoading extends TaskState {}

// edit notes
class EditTasksState extends TaskState {
  final Task task;

  EditTasksState({required this.task});
}

//  your notes
class AllTasksState extends TaskState {
  final List<Task> tasks; // get all notes

  AllTasksState({required this.tasks});
}

// new note
class NewTaskState extends TaskState {}
