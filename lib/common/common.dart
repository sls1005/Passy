import 'package:flutter/material.dart';

Widget getBackButton(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () => Navigator.pop(context),
    );

AppBar getAddScreenAppBar(
  BuildContext context, {
  required String title,
  required VoidCallback onSave,
  bool isNew = false,
}) =>
    AppBar(
      leading: getBackButton(context),
      title: isNew
          ? Center(child: Text('Add $title'))
          : Center(child: Text('Edit $title')),
      actions: [
        IconButton(
          onPressed: onSave,
          icon: isNew
              ? const Icon(Icons.add_rounded)
              : const Icon(Icons.check_rounded),
        ),
      ],
    );
