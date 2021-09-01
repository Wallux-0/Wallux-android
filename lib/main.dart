import 'package:flutter/material.dart';
import 'package:wallux/routes/splash.dart';
import 'package:wallux/routes/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallux',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "splash",
      routes: {
        'splash': (context) => Splash(),
      },
    );
  }
}
