import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallux/routes/wallpaper.dart';

class Home extends StatefulWidget {
  final Map<dynamic, dynamic> res;
  Home({Key? key, required this.res}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int present = 0;
  int perPage = 10;
  var items = <dynamic>[];

  @override
  void initState() {
    super.initState();
    setState(() {
      items.addAll(
          this.widget.res["wallpaper"].getRange(present, present + perPage));
      present = present + perPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.res);
    print("We are in Home");
    String imageLink =
        "https://raw.githubusercontent.com/Wallux-0/Wallpapers/main/compressed/";
    String uncompressed =
        "https://raw.githubusercontent.com/Wallux-0/Wallpapers/main/";
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    var scaffoldKey = GlobalKey<ScaffoldState>();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ),
    );
    String gitHubLink =
        "https://raw.githubusercontent.com/Wallux-0/Wallux/main/static/";
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Column(
          children: [
            Container(
              height: 60,
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              scaffoldKey.currentState!.openDrawer();
                            },
                            icon: Icon(
                              Icons.menu,
                              size: 28,
                            )),
                        Text(
                          "WallUX",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return (AlertDialog(
                                  title: Text(
                                    "Tags",
                                    style: GoogleFonts.poppins(),
                                  ),
                                  content: Text(
                                    "Tag feature is not currently available",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                  elevation: 6,
                                ));
                              });
                        },
                        icon: Icon(
                          Icons.tag,
                          size: 28,
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: width,
              height: height - (24 + 60),
              child: LayoutBuilder(builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Image(
                        width: width,
                        fit: BoxFit.fitWidth,
                        image: AssetImage("assets/appbanner.png"),
                      ),
                      Text(
                        "\nWallpapers\n",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            (present <= this.widget.res["wallpaper"].length)
                                ? items.length + 1
                                : items.length,
                        itemBuilder: (context, index) {
                          return (index == items.length)
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 20),
                                        TextButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                    EdgeInsets>(
                                                EdgeInsets.only(
                                                    left: 20, right: 20)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                            ),
                                            elevation:
                                                MaterialStateProperty.all(3),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            fixedSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(130, 30)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.black87),
                                          ),
                                          child: Text(
                                            "Load More",
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if ((present + perPage) >
                                                  this
                                                      .widget
                                                      .res["wallpaper"]
                                                      .length) {
                                                items.addAll(this
                                                    .widget
                                                    .res["wallpaper"]
                                                    .getRange(
                                                        present,
                                                        this
                                                            .widget
                                                            .res["wallpaper"]
                                                            .length));
                                              } else {
                                                items.addAll(this
                                                    .widget
                                                    .res["wallpaper"]
                                                    .getRange(present,
                                                        present + perPage));
                                              }
                                              present = present + perPage;
                                            });
                                          },
                                        ),
                                        SizedBox(width: 20),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                    ),
                                  ],
                                )
                              : InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FullScreenImagePage(
                                                    imageLink +
                                                        this.widget.res[
                                                                'wallpaper']
                                                            [index]['path'],
                                                    this.widget.res['wallpaper']
                                                        [index]['path'])))
                                  },
                                  child: Container(
                                    width: width - 40,
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 2,
                                            blurRadius: 7,
                                            offset: Offset(1, 1),
                                          )
                                        ]),
                                    child: Column(
                                      children: [
                                        FadeInImage.assetNetwork(
                                          placeholder: 'assets/loading.gif',
                                          width: width - 30,
                                          fit: BoxFit.cover,
                                          image: imageLink +
                                              this.widget.res['wallpaper']
                                                  [index]['path'],
                                        ),
                                        Text(
                                          this.widget.res['wallpaper'][index]
                                              ['name'],
                                          style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          this.widget.res['wallpaper'][index]
                                              ['description'],
                                          style: GoogleFonts.openSans(
                                              color: Colors.black38),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              children: [
                Image(
                  image: AssetImage("assets/appbanner.png"),
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: 40,
                ),
                ListTile(
                  title: Center(
                      child: Text(
                    "WallUX",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                ),
                SizedBox(
                  height: 1,
                ),
                ListTile(
                  title: Text(
                    "About WallUX",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return (AlertDialog(
                            title: Text(
                              "About WallUX",
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                            content: SizedBox(
                              height: 290,
                              child: Column(
                                children: [
                                  Image(
                                    image: AssetImage("assets/appbanner.png"),
                                    fit: BoxFit.fitWidth,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "\nWallUX app will give access to android user to use the various linux distribution background images as wallpaper for lock screen and home screen",
                                      style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            elevation: 6,
                          ));
                        });
                  },
                ),
                ListTile(
                  title: Text(
                    "App Creators",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return (AlertDialog(
                            title: Text(
                              "About Creators",
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                            content: SizedBox(
                              height: 280,
                              child: Column(
                                children: [
                                  Image(
                                    image: AssetImage("assets/appbanner.png"),
                                    fit: BoxFit.fitWidth,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                        text: TextSpan(
                                            text:
                                                "\nCode contributor & App creator:\n",
                                            style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black54,
                                              fontSize: 12,
                                            ),
                                            children: const <TextSpan>[
                                          TextSpan(
                                              text: " Manoj Paramsetti",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: "\n\nImage Contributor:\n"),
                                          TextSpan(
                                              text: "Nannan",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ])),
                                  ),
                                ],
                              ),
                            ),
                            elevation: 6,
                          ));
                        });
                  },
                ),
                ListTile(
                  title: Text(
                    "Credits",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return (AlertDialog(
                            title: Text(
                              "Credits",
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                            content: SizedBox(
                              height: 280,
                              child: Column(
                                children: [
                                  Image(
                                    image: AssetImage("assets/loading.gif"),
                                    fit: BoxFit.fitWidth,
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          text: "\nThe above GIF is created by",
                                          style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                          children: const <TextSpan>[
                                        TextSpan(
                                            text: " Edgar Vehbiu",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text:
                                                " and this GIF is taken from "),
                                        TextSpan(
                                            text: "Dribble",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ])),
                                ],
                              ),
                            ),
                            elevation: 6,
                          ));
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Text(
//    this.res['wallpaper'][index]['name']
//    +" "+ imageLink+
//    (this.res['wallpaper'][index]['path']
//  ),
//)
