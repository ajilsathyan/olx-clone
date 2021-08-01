import 'package:flutter/material.dart';

Widget buildCustomProgressIndicator(context) {
  return SizedBox(
    width: 30,
    height: 30,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    ),
  );
}
