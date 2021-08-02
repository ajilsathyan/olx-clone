import 'package:flutter/material.dart';

InputDecoration inputDecorationForTextField({
  context,
  labelText,
  helperText,
  prefixText,
}) {
  return InputDecoration(
    labelText: labelText,
    helperText: helperText,
    prefixText: prefixText,
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 0.5),
    ),
    focusColor: Theme.of(context).primaryColor,
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor),
    ),
  );
}
