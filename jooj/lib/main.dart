import 'package:flutter/material.dart';

import 'pages/PaginaLogin.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.yellow,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.lightGreenAccent,
    ),
    home: PaginaLogin(),
  ));
}
