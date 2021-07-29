import 'package:agrobank_test/repositories/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agrobank_test/bloc/tasks/task_bloc.dart';

class EditTaskScreen extends StatefulWidget {
  final Task? task;
  final int? index;
  EditTaskScreen({Key? key, this.task, this.index}) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  List<String> _statusList = ['В прогрессе', 'Выполнено'];

  @override
  Widget build(BuildContext context) {
    String _title = widget.task!.title;
    DateTime _date = widget.task!.date;
    String _status = widget.task!.status;

    TextEditingController _titleController =
        TextEditingController(text: _title);
    TextEditingController _dateController =
        TextEditingController(text: _date.toString());

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
          'Изменить Задачу',
        ),
      ),
      floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 10, bottom: 10),
          child: FloatingActionButton.extended(
            icon: Icon(Icons.add),
            label: Text('Изменить'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                BlocProvider.of<TaskBloc>(context).add(TaskEditEvent(
                    title: _title,
                    status: _status,
                    date: DateTime.parse(_dateController.text),
                    index: widget.index));
                Navigator.pop(context);
              }
            },
          )),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              validator: (input) =>
                  input!.trim().isEmpty ? 'Введите название' : null,
              decoration: InputDecoration(labelText: 'Название'),
              onSaved: (input) => _title = input!,
              onChanged: (input) => _title = input,
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
              validator: (input) => _status.isEmpty ? 'Выберите статус' : null,
              onChanged: (newValue) {
                setState(() => _status = newValue.toString());
              },
              value: _status,
              onSaved: (newValue) {
                setState(() => _status = newValue.toString());
              },
            )
          ],
        ),
      ),
    );
  }
}
