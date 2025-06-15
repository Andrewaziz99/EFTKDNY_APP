import 'package:flutter/material.dart';

import '../../shared/components/constants.dart';

Widget buildMonthPickerDialog(
  BuildContext context, {
  required Function(int) onDateSelected,
}) {
  return AlertDialog(
    title: const Text('اختر الشهر'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(months.length, (index) {
          return ListTile(
            title: Text(months.keys.elementAt(index)),
            onTap: () {
              Navigator.of(context).pop();
              onDateSelected(months.values.elementAt(index));
            },
          );
        }),
      ),
    ),
  );
}