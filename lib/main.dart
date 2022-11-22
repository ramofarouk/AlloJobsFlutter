import 'dart:async';
import 'dart:io';

import 'package:allojobstogo/screens/auth/login_screen.dart';
import 'package:allojobstogo/screens/candidats/dashboard_screen.dart';
import 'package:allojobstogo/screens/entreprises/dashboard_entreprise_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/constants.dart';
import 'utils/preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.light : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    Map<int, Color> color = {
      50: Color.fromRGBO(15, 106, 78, .1),
      100: Color.fromRGBO(15, 106, 78, .2),
      200: Color.fromRGBO(15, 106, 78, .3),
      300: Color.fromRGBO(15, 106, 78, .4),
      400: Color.fromRGBO(15, 106, 78, .5),
      500: Color.fromRGBO(15, 106, 78, .6),
      600: Color.fromRGBO(15, 106, 78, .7),
      700: Color.fromRGBO(15, 106, 78, .8),
      800: Color.fromRGBO(15, 106, 78, .9),
      900: Color.fromRGBO(15, 106, 78, 1),
    };
    return MaterialApp(
      title: Constants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: currentFontFamily,
        primarySwatch: MaterialColor(0xFF0F6A4E, color),
        primaryColor: Constants.primaryColor,
      ),
      home: SplashScreen(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ignore: invalid_use_of_visible_for_testing_member
    //SharedPreferences.setMockInitialValues({});
    Timer(Duration(seconds: 5), () {
      _checkData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement build
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Constants.primaryColor,
                  Constants.primaryColor,
                  Constants.primaryColor,
                  Constants.primaryColor,
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 60.0,
                          child: AssetImageMap(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        Text(
                          Constants.appName,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 19.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),
                        Text(
                          Constants.appDescription,
                          style: TextStyle(
                              color: Colors.white,
                              //fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        )
                      ],
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }

  _checkData() async {
    Future<int> stepAuth = SharedPreferencesHelper.getIntValue("step_auth");
    stepAuth.then((int value) async {
      if (value == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
      } else {
        Future<int> typeUser = SharedPreferencesHelper.getIntValue("type_user");
        typeUser.then((int value) async {
          if (value == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return DashboardScreen(0);
            }));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return DashboardEntrepriseScreen(0);
            }));
          }
        });
      }
    });
  }
}

class AssetImageMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage imageAsset = AssetImage('assets/images/logo.png');
    Image image = Image(
      image: imageAsset,
      width: 150.0,
      height: 150.0,
    );
    return image;
  }
}
