import 'package:agrobank_test/bloc/bottom_navigation/bottomnavigation_bloc.dart';
import 'package:agrobank_test/bloc/tasks/task_bloc.dart';
import 'package:agrobank_test/screens/edit_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BottomnavigationBloc? _navbarBloc;

  @override
  void initState() {
    super.initState();
    _navbarBloc = BottomnavigationBloc();
  }

  @override
  void dispose() {
    _navbarBloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _navbarBloc,
      builder: (BuildContext context, BottomnavigationState state) {
        if (state is ShowAll)
          return buildHomepage(state.title, Colors.blue, state.itemIndex);
        if (state is ShowTasksInProgress)
          return buildHomepage(state.title, Colors.green, state.itemIndex);
        if (state is ShowDoneTasks)
          return buildHomepage(state.title, Colors.red, state.itemIndex);
        return CircularProgressIndicator();
      },
    );
  }

  Scaffold buildHomepage(String title, Color color, int currentIndex) {
    return Scaffold(
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskInitial) {
            return Container(
              color: Colors.green,
            );
          }
          if (state is YourTasksState) {
            return ListView.builder(
              itemBuilder: (BuildContext context, index) {
                final task = state.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.date.toString()),
                  trailing: Text(task.status),
                );
              },
              itemCount: state.tasks.length,
            );
          }
          if (state is TasksLoading) {
            return CircularProgressIndicator();
          } else {
            return Container(
              color: Colors.red,
            );
          }
        },
      ),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddTaskScreen(
                      newTask: true,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.add)),
        ],
        title: Text('Задачи'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) _navbarBloc!.emit(ShowAll());
          if (index == 1) _navbarBloc!.emit(ShowTasksInProgress());
          if (index == 2) _navbarBloc!.emit(ShowDoneTasks());
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Все',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: 'В прогрессе',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Выполнено',
          ),
        ],
      ),
    );
  }
}
