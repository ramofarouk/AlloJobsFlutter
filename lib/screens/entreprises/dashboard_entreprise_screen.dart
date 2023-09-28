import 'dart:io';

import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'dart:async';

import '../auth/login_screen.dart';
import 'home_screen.dart';
import 'list_entreprises_screen.dart';
import 'profile_screen.dart';

class DashboardEntrepriseScreen extends StatefulWidget {
  final int preIndex;
  const DashboardEntrepriseScreen(this.preIndex, {super.key});
  @override
  DashboardEntrepriseScreenState createState() =>
      DashboardEntrepriseScreenState();
}

class DashboardEntrepriseScreenState extends State<DashboardEntrepriseScreen>
    with SingleTickerProviderStateMixin {
  String name = "";
  String phone = "";

  Future<String> nom = SharedPreferencesHelper.getValue("nom");
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
    messaging.subscribeToTopic("allojobsentreprise");
    token.then((String value) async {
      // print(value);
      setState(() {
        messaging.subscribeToTopic("allojobsentreprise$value");
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
        name = value;
      });
    });

    setState(() {
      _currentIndex = widget.preIndex;
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    _widgetOptions = <Widget>[
      HomeScreen(),
      ListEntreprisesScreen(),
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
              padding: EdgeInsets.all(7),
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 30,
                    width: 30,
                  )),
            ),
            title: const Text(
              'RECRUTEUR',
              style: TextStyle(
                  // headline6 is used for setting title's theme
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: currentFontFamily,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              (isAuth)
                  ? PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      elevation: 4,
                      onSelected: (value) {
                        switch (value) {
                          case 2:
                            _showLogoutDialog("Déconnexion",
                                "Êtes-vous sûr de vous déconnecter ?");
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 2,
                              child: Text("Déconnexion"),
                            )
                          ])
                  : const Center()
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
      strokeColor: const Color(0x30040307),
      unSelectedColor: const Color(0xffacacac),
      backgroundColor: Colors.white,
      items: [
        CustomNavigationBarItem(
          icon: const Icon(Icons.person),
          title: const Text("Candidats"),
        ),
        CustomNavigationBarItem(
          icon: const Icon(Icons.business),
          title: const Text("Entreprises"),
        ),
        CustomNavigationBarItem(
          icon: const Icon(Icons.settings),
          title: const Text("Profil"),
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
                  padding: const EdgeInsets.only(
                      left: 10, top: 20 + 20, right: 10, bottom: 10),
                  margin: const EdgeInsets.only(top: 47),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 10),
                            blurRadius: 10),
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        "Alerte",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Êtes-vous sûr de quitter l'application?",
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: const Text('Fermer',
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Constants.primaryColor,
                              ),
                              child: const Text('OUI',
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40)),
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
                  padding: const EdgeInsets.only(
                      left: 10, top: 20 + 20, right: 10, bottom: 10),
                  margin: const EdgeInsets.only(top: 47),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
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
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        content,
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: const Text('Non',
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Constants.primaryColor,
                              ),
                              child: const Text('Oui',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                SharedPreferencesHelper.setIntValue(
                                    "step_auth", 0);
                                FirebaseMessaging.instance
                                    .unsubscribeFromTopic("allojobsentreprise");
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40)),
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
}
