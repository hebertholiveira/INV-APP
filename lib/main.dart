import 'package:flutter/material.dart';

import 'Login.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
      primaryColor: Colors.red,
      accentColor: Colors.pink
    ),
  ));
}
