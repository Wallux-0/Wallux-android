import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:dio/dio.dart';

class FullScreenImagePage extends StatefulWidget {
  String img;
  String name;
  FullScreenImagePage(this.img, this.name);
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<FullScreenImagePage> {
  static const platform = const MethodChannel('funpanrom/wallpaper');
  bool downloading = false;
  var progressString = "";
  // Get battery level.
  String _setWallpaper = '';
  double _promptOpacity = 0.0;
  String compressed =
      "https://raw.githubusercontent.com/Wallux-0/Wallpapers/main/compressed/";
  String uncompressed =
      "https://raw.githubusercontent.com/Wallux-0/Wallpapers/main/";

  Future<Null> setWallpaper(int n) async {
    Dio dio = Dio();
    try {
      var dir = await getTemporaryDirectory();
      print(dir);
      print(widget.name);
      await dio.download(uncompressed + widget.img, dir.path + "/myimg.jpg",
          onReceiveProgress: (rec, total) {
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          print(progressString);
          if (progressString == "100%") {
            _setWallpaer(n);
          }
        });
      });
    } catch (e) {}

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("completed");
  }

  Future<Null> _setWallpaer(int n) async {
    String setWallpaper;
    try {
      var dir = await getTemporaryDirectory();

      final int result = await platform
          .invokeMethod('setWallpaper', [dir.path + '/myimg.jpg', n]);
      setWallpaper = 'Wallpaper Changed';
    } on PlatformException catch (e) {
      setWallpaper = "Something went wrong";
      //setWallpaper = "Failed to Set Wallpaer: '${e.message}'.";
    }

    setState(() {
      _setWallpaper = setWallpaper;
      _promptOpacity = 1.0;
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _setWallpaper = " ";
        _promptOpacity = 0.0;
      });
    });
  }

  Future<Null> download() async {
    var downloadPath = "/storage/emulated/0/Download/";
    final taskId = await FlutterDownloader.enqueue(
      url: widget.img,
      savedDir: downloadPath + widget.name,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    print(downloadPath + widget.name);
    _download();
    print("completed");
  }

  Future<Null> _download() async {
    setState(() {
      _promptOpacity = 1.0;
      _setWallpaper =
          "This feature will be coming soon";
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _setWallpaper = " ";
        _promptOpacity = 0.0;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Future<Null> setWallpaper() async {
      WidgetsFlutterBinding.ensureInitialized();
      await FlutterDownloader.initialize(
          debug:
              false // optional: set false to disable printing logs to console
          );
    }
  }

  final LinearGradient bg = new LinearGradient(
      colors: [new Color(0x10000000), new Color(0x30000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("WallUX",
            style: GoogleFonts.poppins(
              //  color: Colors.black87,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop()),
        //backgroundColor: Colors.white,
        //foregroundColor: Colors.black54,
        backgroundColor: const Color(0xFF010101).withOpacity(1.0),
      ),
      backgroundColor: Colors.white,
      //backgroundColor: const Color(0xFF010101).withOpacity(1.0),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(gradient: bg),
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  Text("\nSet Wallpaper",
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontSize: 19.0,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text(
                          "Home Screen",
                          style: GoogleFonts.poppins(
                              fontSize: 12.0, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          print("Reloading...");
                          setWallpaper(1);
                        },
                      ),
                      TextButton(
                        child: Text(
                          "Lock Screen",
                          style: GoogleFonts.poppins(
                              fontSize: 12.0, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          print("Reloading...");
                          setWallpaper(2);
                        },
                      ),
                      TextButton(
                        child: Text(
                          "Both",
                          style: GoogleFonts.poppins(
                              fontSize: 12.0, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          print("Reloading...");
                          setWallpaper(3);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.download,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          _download();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: Hero(
                      tag: widget.img,
                      child: Image.network(compressed + widget.img)),
                ),
              ),
              Align(
                alignment: Alignment(0.0, 0.7),
                child: Row(
                  children: [
                    Opacity(
                      opacity: _promptOpacity,
                      child: Material(
                        elevation: 1,
                        child: Container(
                          color: Colors.pink,
                          width: 5,
                          height: 50,
                          padding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: _promptOpacity,
                      child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(1, 1),
                                )
                              ]),
                          alignment: Alignment.center,
                          //width: whiteDialog,
                          padding: EdgeInsets.all(8),
                          child: Text(_setWallpaper,
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontSize: 13.0,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[],
                ),
              ),
              Align(
                alignment: Alignment(0.0, 0.0),
                child: Center(
                    child: downloading
                        ? Container(
                            height: 120.0,
                            width: 200.0,
                            child: Card(
                              color: Colors.black,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  SizedBox(height: 20.0),
                                  Text(
                                    "Downloading File : $progressString",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Text("")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
