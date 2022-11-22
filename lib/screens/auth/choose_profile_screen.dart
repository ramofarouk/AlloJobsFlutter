import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:allojobstogo/screens/auth/register_screen.dart';
import 'package:allojobstogo/utils/constants.dart';

class ChooseProfileScreen extends StatefulWidget {
  String telephone, pays;
  ChooseProfileScreen(this.telephone, this.pays);

  @override
  _ChooseProfileScreenState createState() =>
      _ChooseProfileScreenState(this.telephone, this.pays);
}

class _ChooseProfileScreenState extends State<ChooseProfileScreen> {
  String telephone, pays;
  _ChooseProfileScreenState(this.telephone, this.pays);

  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back1.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.linearToSrgbGamma(),
            ),
          ),
          child: Container(
            height: hauteur,
            padding: EdgeInsets.symmetric(horizontal: largeur / 17),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _keyForm,
                  child: Container(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: largeur / 14,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage("assets/images/header.png"),
                            width: 200.0,
                            height: 200.0,
                          ),
                          Text(
                            "Je choisis mon profil",
                            style: TextStyle(
                              color: Color(0xff303030),
                              fontSize: 20,
                              fontFamily: currentFontFamily,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            width: double.infinity,
                            child: RaisedButton(
                              elevation: 5.0,
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return RegisterScreen(1, telephone, pays);
                                }));
                              },
                              padding: EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Constants.primaryColor,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.userAlt,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'CLIENT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: currentFontFamily,
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            width: double.infinity,
                            child: RaisedButton(
                                elevation: 5.0,
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return RegisterScreen(2, telephone, pays);
                                  }));
                                },
                                padding: EdgeInsets.all(10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.white,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.motorcycle,
                                        size: 20,
                                        color: Color(0xFF00684F),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'CONDUCTEUR MOTO',
                                        style: TextStyle(
                                          color: Color(0xFF00684F),
                                          letterSpacing: 1.5,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: currentFontFamily,
                                        ),
                                      ),
                                    ])),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            width: double.infinity,
                            child: RaisedButton(
                                elevation: 5.0,
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return RegisterScreen(3, telephone, pays);
                                  }));
                                },
                                padding: EdgeInsets.all(10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.orange,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.caravan,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'CONDUCTEUR TRICYCLE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: currentFontFamily,
                                        ),
                                      ),
                                    ])),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            width: double.infinity,
                            child: RaisedButton(
                                elevation: 5.0,
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return RegisterScreen(4, telephone, pays);
                                  }));
                                },
                                padding: EdgeInsets.all(10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.black,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.car,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'CONDUCTEUR VOITURE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: currentFontFamily,
                                        ),
                                      ),
                                    ])),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
