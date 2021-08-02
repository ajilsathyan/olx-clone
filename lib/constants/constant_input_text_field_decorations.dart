import 'package:flutter/material.dart';

InputDecoration inputDecorationForTextField({
  context,
  labelText,
  helperText,
  prefixText,
  hintText,
}) {
  return InputDecoration(
    labelText: labelText,
    helperText: helperText,
    prefixText: prefixText,
    hintText: hintText,
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1),
    ),
    focusColor: Theme.of(context).primaryColor,
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.5),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor),
    ),
  );
}
