import 'dart:io';

import 'package:allojobstogo/screens/candidats/home_screen.dart';
import 'package:allojobstogo/screens/candidats/list_candidats_screen.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../auth/login_screen.dart';
import 'profile_screen.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
  Vibration.vibrate(
    pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
    intensities: [128, 255, 64, 255],
  );
  FlutterBeep.playSysSound(39);
}

class DashboardScreen extends StatefulWidget {
  int preIndex;
  DashboardScreen(this.preIndex);
  @override
  _DashboardScreenState createState() => _DashboardScreenState(this.preIndex);
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int preIndex;
  _DashboardScreenState(this.preIndex);
  String firstName = "";
  String lastName = "";
  String phone = "";

  Future<String> nom = SharedPreferencesHelper.getValue("nom");
  Future<String> prenoms = SharedPreferencesHelper.getValue("prenoms");
  Future<String> telephone = SharedPreferencesHelper.getValue("telephone");
  Future<String> token = SharedPreferencesHelper.getValue("token");

  String idUser = "";
  Future<int> id = SharedPreferencesHelper.getIntValue("id");

  Future<int> auth = SharedPreferencesHelper.getIntValue("step_auth");
  late int _currentIndex;

  late double value;
  late AnimationController _controller;

  late List<Widget> _widgetOptions;
  void _onItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  bool isAuth = false;
  late FirebaseMessaging messaging;

  @override
  void initState() {
    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("allojobs");
    token.then((String value) async {
      // print(value);
      setState(() {
        messaging.subscribeToTopic("allojobs" + value);
      });
    });
    id.then((int value) async {
      // print(value);
      setState(() {
        idUser = value.toString();
      });
    });
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      Vibration.vibrate(
        pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
        intensities: [128, 255, 64, 255],
      );
      FlutterBeep.playSysSound(39);
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Alerte"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    auth.then((int value) async {
      // print(value);
      setState(() {
        if (value == 1) {
          isAuth = true;
        }
      });
    });

    telephone.then((String value) async {
      // print(value);
      setState(() {
        phone = value;
      });
    });

    nom.then((String value) async {
      // print(value);
      setState(() {
        lastName = value;
      });
    });
    prenoms.then((String value) async {
      // print(value);
      setState(() {
        firstName = value;
      });
    });
    setState(() {
      _currentIndex = preIndex;
    });

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    _widgetOptions = <Widget>[
      HomeScreen(_controller),
      ListCandidatScreen(_controller),
      ProfileScreen()
    ];

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Constants.primaryColor,
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 30,
                    width: 30,
                  )),
              padding: EdgeInsets.all(7),
            ),
            title: Text(
              'ALL??JOBS',
              style: TextStyle(
                  // headline6 is used for setting title's theme
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: currentFontFamily,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              (isAuth)
                  ? PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      elevation: 4,
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            _showDeleteAccount("Suppression de compte",
                                "??tes-vous s??r de vous de supprimer votre compte ?");
                            break;
                          case 2:
                            _showLogoutDialog("D??connexion",
                                "??tes-vous s??r de vous d??connecter ?");
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text("D??connexion"),
                              value: 2,
                            ),
                            PopupMenuItem(
                              child: Text("Supprimer mon compte"),
                              value: 1,
                            )
                          ])
                  : Center()
            ],
          ),
          body: Center(child: _widgetOptions.elementAt(_currentIndex)),
          bottomNavigationBar: _buildBottomNavigationBar(),
        ));
  }

  Widget _buildBottomNavigationBar() {
    return _buildTitle();
  }

  Widget _buildTitle() {
    return CustomNavigationBar(
      iconSize: 35.0,
      selectedColor: Constants.primaryColor,
      strokeColor: Color(0x30040307),
      unSelectedColor: Color(0xffacacac),
      backgroundColor: Colors.white,
      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.business),
          title: Text("Entreprises"),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text("Candidats"),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text("Profil"),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        _onItemTap(index);
      },
    );
  }

  Future<bool> _onBackPressed() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      left: 10, top: 20 + 20, right: 10, bottom: 10),
                  margin: EdgeInsets.only(top: 47),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 10),
                            blurRadius: 10),
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Alerte",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "??tes-vous s??r de quitter l'application?",
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              child: Text('Fermer',
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                            FlatButton(
                              color: Constants.primaryColor,
                              child: Text('OUI',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                exit(0);
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 70,
                          width: 70,
                        )),
                  ),
                ),
              ],
            ),
          );
        });
    return Future.value(false);
  }

  void _showLogoutDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      left: 10, top: 20 + 20, right: 10, bottom: 10),
                  margin: EdgeInsets.only(top: 47),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 10),
                            blurRadius: 10),
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        content,
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          children: [
                            FlatButton(
                              child: Text('Non',
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                            FlatButton(
                              color: Constants.primaryColor,
                              child: Text('Oui',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                initializePreferences(context);
                                token.then((String value) async {
                                  FirebaseMessaging.instance
                                      .unsubscribeFromTopic("mauto" + value);
                                });
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                    (Route<dynamic> route) => false);
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 50,
                          width: 50,
                        )),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _showDeleteAccount(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      left: 10, top: 20 + 20, right: 10, bottom: 10),
                  margin: EdgeInsets.only(top: 47),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 10),
                            blurRadius: 10),
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        content,
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          children: [
                            FlatButton(
                              child: Text('Non',
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                            FlatButton(
                              color: Constants.primaryColor,
                              child: Text('Oui',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                _deleteAccount();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 50,
                          width: 50,
                        )),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _deleteAccount() async {
    final response = await http.post(
        Uri.parse(
            Constants.host + "/api/auth/delete-user?token=" + Constants.token),
        body: {'id': idUser.toString()});
    print(response.body);
    var dataUser = json.decode(response.body);
    initializePreferences(context);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  Future<void> initializePreferences(BuildContext context) async {
    SharedPreferencesHelper.setIntValue("step_auth", 0);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
