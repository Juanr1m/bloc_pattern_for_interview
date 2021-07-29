import 'package:flutter/material.dart';

AppBar buildAppBar() {
  return AppBar(
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton(
          icon: Icon(Icons.settings),
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
  );
}
