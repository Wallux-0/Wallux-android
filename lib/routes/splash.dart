import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallux/routes/home.dart';

class Splash extends StatefulWidget {
  Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> res = {};
    Future<Map> getImages() async {
      var url = Uri.parse(
          'https://raw.githubusercontent.com/Wallux-0/Wallux/main/static/tags.json');
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      res = jsonDecode(response.body);
      return res;
    }

    Future.delayed(Duration(seconds: 3), () {
      getImages().then((result) {
        print(result["wallpaper"]);
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Home(res: result)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Scaffold(
      body: Container(
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                  width: 220.0,
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/walluxlogo.png')),
            ],
          ),
        ),
      ),
    );
  }
}
