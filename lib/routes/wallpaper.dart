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

  Future<Null> setWallpaper() async {
    Dio dio = Dio();
    try {
      var dir = await getTemporaryDirectory();
      print(dir);
      print(widget.name);
      await dio.download(widget.img, dir.path + "/" + widget.name,
          onReceiveProgress: (rec, total) {
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          print(progressString);
          if (progressString == "100%") {
            _setWallpaer();
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

  Future<Null> _setWallpaer() async {
    String setWallpaper;
    try {
      var dir = await getTemporaryDirectory();

      final int result = await platform
          .invokeMethod('setWallpaper', [dir.path + '/myimag.jpg', 1]);
      setWallpaper = 'Wallpaper Changed';
    } on PlatformException catch (e) {
      setWallpaper = "Something went wrong";
      //setWallpaper = "Failed to Set Wallpaer: '${e.message}'.";
    }

    setState(() {
      _setWallpaper = setWallpaper;
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _setWallpaper = " ";
      });
    });
  }

  Future<Null> setLockscreen() async {
    Dio dio = Dio();
    try {
      var dir = await getTemporaryDirectory();
      print(dir);

      await dio.download(widget.img, dir.path + "/myimag.jpg",
          onReceiveProgress: (rec, total) {
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          print(progressString);
          if (progressString == "100%") {
            _setLockscreen();
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

  Future<Null> _setLockscreen() async {
    String setWallpaper;
    try {
      var dir = await getTemporaryDirectory();

      final int result = await platform
          .invokeMethod('setWallpaper', [dir.path + '/myimag.jpg', 2]);
      setWallpaper = 'Wallpaper Changed';
    } on PlatformException catch (e) {
      setWallpaper = "Something went wrong";
      //setWallpaper = "Failed to Set Wallpaer: '${e.message}'.";
    }

    setState(() {
      _setWallpaper = setWallpaper;
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _setWallpaper = " ";
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
    _download();
    print("completed");
  }

  Future<Null> _download() async {
    setState(() {
      _setWallpaper =
          "This feature will be coming soon\nCurrently, Enjoy this app by setting up the wallpaper for your phone";
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _setWallpaper = " ";
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
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
        title: Text("WallUX"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop()),
        backgroundColor: const Color(0xFF010101).withOpacity(1.0),
      ),
      backgroundColor: const Color(0xFF010101).withOpacity(1.0),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(gradient: bg),
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  Text("\nSet Wallpaper",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 19.0,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        //icon: new Icon(Icons.wallpaper),
                        child: Text("Home Screen"),
                        onPressed: () {
                          print("Reloading...");
                          setWallpaper();
                        },
                      ),
                      TextButton(
                        //icon: new Icon(Icons.wallpaper),
                        child: Text("Lock Screen"),
                        onPressed: () {
                          print("Reloading...");
                          setLockscreen();
                        },
                      ),
                      TextButton(
                        //icon: new Icon(Icons.wallpaper),
                        child: Text(
                          "Download",
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 12.0,
                          ),
                        ),
                        onPressed: () {
                          print("Reloading...");
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
                  child:
                      Hero(tag: widget.img, child: Image.network(widget.img)),
                ),
              ),
              Align(
                alignment: Alignment(0.0, 0.7),
                child: Text(_setWallpaper,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13.0,
                    )),
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
