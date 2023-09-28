import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:allojobstogo/screens/auth/register_screen.dart';
import 'package:allojobstogo/utils/constants.dart';

class ChooseProfileScreen extends StatefulWidget {
  final String telephone, pays;
  const ChooseProfileScreen(this.telephone, this.pays, {super.key});

  @override
  ChooseProfileScreenState createState() => ChooseProfileScreenState();
}

class ChooseProfileScreenState extends State<ChooseProfileScreen> {
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
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
                    padding: EdgeInsets.symmetric(
                      horizontal: largeur / 14,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage("assets/images/header.png"),
                          width: 200.0,
                          height: 200.0,
                        ),
                        const Text(
                          "Je choisis mon profil",
                          style: TextStyle(
                            color: Color(0xff303030),
                            fontSize: 20,
                            fontFamily: currentFontFamily,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5.0,
                              padding: const EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              backgroundColor: Constants.primaryColor,
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return RegisterScreen(
                                    1, widget.telephone, widget.pays);
                              }));
                            },
                            child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.userLarge,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'DEMANDEUR',
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
                          padding: const EdgeInsets.all(5),
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5.0,
                                padding: const EdgeInsets.all(10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                backgroundColor: Constants.thridColor,
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return RegisterScreen(
                                      2, widget.telephone, widget.pays);
                                }));
                              },
                              child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.building,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'EMPLOYEUR',
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
              ],
            ),
          )),
    );
  }
}
