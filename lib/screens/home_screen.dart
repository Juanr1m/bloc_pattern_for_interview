import 'package:agrobank_test/bloc/bottom_navigation/bottomnavigation_bloc.dart';
import 'package:agrobank_test/bloc/bottom_navigation/bottomnavigation_event.dart';
import 'package:agrobank_test/bloc/tasks/task_bloc.dart';
import 'package:agrobank_test/screens/edit_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'add_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BottomnavigationBloc? _navbarBloc;
  final DateFormat _dateFormatter = DateFormat('MMM dd');

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
        if (state is ShowAll) return buildHomepage(state.itemIndex);
        if (state is ShowTasksInProgress) return buildHomepage(state.itemIndex);
        if (state is ShowDoneTasks) return buildHomepage(state.itemIndex);
        return CircularProgressIndicator();
      },
    );
  }

  Scaffold buildHomepage(int currentIndex) {
    return Scaffold(
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is AllTasksState) {
            if (state.tasks.isEmpty) {
              return Center(
                child: Text('Нет информации'),
              );
            }
            if (_navbarBloc!.state is ShowAll) {
              return ListView.builder(
                itemBuilder: (BuildContext context, index) {
                  final task = state.tasks[index];
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Редактировать',
                        color: Colors.black45,
                        icon: Icons.edit,
                        onTap: () => {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return EditTaskScreen(
                              task: task,
                              index: index,
                            );
                          }))
                        },
                      ),
                      IconSlideAction(
                        caption: 'Удалить',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          BlocProvider.of<TaskBloc>(context)
                              .add(TaskDeleteEvent(index: index));
                        },
                      ),
                    ],
                    child: ListTile(
                      onTap: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return EditTaskScreen(
                            task: task,
                            index: index,
                          );
                        }))
                      },
                      title: Text(task.title),
                      subtitle: Text(_dateFormatter.format(task.date) +
                          '  ' +
                          task.status),
                      trailing: Icon(Icons.more),
                    ),
                  );
                },
                itemCount: state.tasks.length,
              );
            }

            if (_navbarBloc!.state is ShowTasksInProgress) {
              return ListView.builder(
                itemBuilder: (BuildContext context, index) {
                  final task = state.tasks[index];
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Редактировать',
                        color: Colors.black45,
                        icon: Icons.edit,
                        onTap: () => {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return EditTaskScreen(
                              task: task,
                              index: index,
                            );
                          }))
                        },
                      ),
                      IconSlideAction(
                        caption: 'Удалить',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          BlocProvider.of<TaskBloc>(context)
                              .add(TaskDeleteEvent(index: index));
                        },
                      ),
                    ],
                    child: ListTile(
                      tileColor: Colors.red,
                      onTap: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return EditTaskScreen(
                            task: task,
                            index: index,
                          );
                        }))
                      },
                      title: Text(task.title),
                      subtitle: Text(_dateFormatter.format(task.date) +
                          '  ' +
                          task.status),
                      trailing: Icon(Icons.more),
                    ),
                  );
                },
                itemCount: state.tasks.length,
              );
            }
            if (_navbarBloc!.state is ShowDoneTasks) {
              return ListView.builder(
                itemBuilder: (BuildContext context, index) {
                  final task = state.tasks[index];
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Редактировать',
                        color: Colors.black45,
                        icon: Icons.edit,
                        onTap: () => {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return EditTaskScreen(
                              task: task,
                              index: index,
                            );
                          }))
                        },
                      ),
                      IconSlideAction(
                        caption: 'Удалить',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          BlocProvider.of<TaskBloc>(context)
                              .add(TaskDeleteEvent(index: index));
                        },
                      ),
                    ],
                    child: ListTile(
                      tileColor: Colors.green,
                      onTap: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return EditTaskScreen(
                            task: task,
                            index: index,
                          );
                        }))
                      },
                      title: Text(task.title),
                      subtitle: Text(_dateFormatter.format(task.date) +
                          '  ' +
                          task.status),
                      trailing: Icon(Icons.more),
                    ),
                  );
                },
                itemCount: state.tasks.length,
              );
            }
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
              icon: Icon(Icons.settings, color: Colors.white),
              items: [
                'В порядке возрастания сроков',
                'В порядке убывания сроков',
              ].map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          )
        ],
        title: Text('Задачи'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => AddTaskScreen(),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) _navbarBloc!.add(NavbarItems.All);
          if (index == 1) _navbarBloc!.add(NavbarItems.Progress);
          if (index == 2) _navbarBloc!.add(NavbarItems.Done);
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
