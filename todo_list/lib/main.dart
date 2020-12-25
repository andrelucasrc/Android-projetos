import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Pages/StartPage.dart';

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.purple,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.blueAccent,
          fontFamily: "ComicSansMS",
        ),
        home: StartPage(),
  ));
}
