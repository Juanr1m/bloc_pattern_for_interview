import 'package:agrobank_test/repositories/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:agrobank_test/bloc/tasks/task_bloc.dart';

class EditTaskScreen extends StatefulWidget {
  final bool newTask;
  final Task? task;
  final int? index;
  EditTaskScreen({Key? key, required this.newTask, this.task, this.index})
      : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  List<String> _statusList = ['В прогрессе', 'Выполнено'];
  final DateFormat _dateFormatter = DateFormat('MMM dd');
  @override
  Widget build(BuildContext context) {
    String _title = widget.task != null ? widget.task!.title : '';
    DateTime _date = widget.task != null ? widget.task!.date : DateTime.now();
    String _status = widget.task != null ? widget.task!.status : '';

    TextEditingController _titleController =
        TextEditingController(text: _title);
    TextEditingController _dateController =
        TextEditingController(text: _date == null ? null : _date.toString());
    TextEditingController _statusController =
        TextEditingController(text: _status);

    _handleDatePicker() async {
      final DateTime? date = await showDatePicker(
          context: context,
          initialDate: _date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100));
      if (date != null && date != _date) {
        setState(() {
          _date = date;
        });
        _dateController.text = _date.toString();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.newTask ? 'Новая Задача' : 'Изменить Задачу',
        ),
      ),
      floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 10, bottom: 10),
          child: FloatingActionButton.extended(
            icon: Icon(Icons.add),
            label: Text(widget.newTask ? 'Добавить' : 'Изменить'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.newTask
                    ? BlocProvider.of<TaskBloc>(context).add(TaskAddEvent(
                        title: _titleController.text,
                        date: DateTime.parse(_dateController.text),
                        status: _statusController.text))
                    : BlocProvider.of<TaskBloc>(context).add(TaskEditEvent(
                        title: _titleController.text,
                        status: _statusController.text,
                        date: DateTime.parse(_dateController.text),
                        index: widget.index));
                Navigator.pop(context);
              }
            },
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  validator: (input) =>
                      input!.trim().isEmpty ? 'Введите название' : null,
                  decoration: InputDecoration(labelText: 'Название'),
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Дата'),
                  onTap: _handleDatePicker,
                ),
                DropdownButtonFormField(
                  icon: Icon(Icons.arrow_drop_down_circle),
                  iconSize: 22,
                  items: _statusList.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Статус'),
                  validator: (input) =>
                      _status.isEmpty ? 'Выберите статус' : null,
                  onChanged: (newValue) {
                    setState(() => _status = newValue.toString());
                  },
                  value: _status.isEmpty ? null : _status,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
