import 'package:flutter/material.dart';

Future<bool?> myDialog(
  BuildContext context, {
  required String title,
  required String content,
  required List<Widget> actions,
}) async {
  return showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions,
        ),
  );
}
