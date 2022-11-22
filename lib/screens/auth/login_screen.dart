import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:allojobstogo/screens/auth/password_screen.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/widgets/custom_widget.dart';
import 'package:allojobstogo/widgets/header_widget.dart';

import 'choose_profile_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String telephone = "";
  String indicatif = "+228";
  String pays = "";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    final mQ = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          HeaderWidget(height: mQ.height * 0.5),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  "Hello, ravi de vous revoir!",
                  style: TextStyle(
                    color: Color(0xff303030),
                    fontSize: 12,
                    fontFamily: currentFontFamily,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Votre application de mise en relation professionelle",
                  style: TextStyle(
                    color: Color(0xff303030),
                    fontSize: 18,
                    fontFamily: currentFontFamily,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            margin: EdgeInsets.only(left: 20, right: 20),
            elevation: 6.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: CountryCodePicker(
                      onChanged: (e) {
                        setState(() {
                          indicatif = e.code.toString();
                          pays = e.name.toString();
                          print(pays);
                        });
                      },
                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      initialSelection: 'TG',
                      favorite: ['+228', 'TG'],
                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                      // optional. Shows only country name and flag when popup is closed.
                      showOnlyCountryWhenClosed: false,
                      // optional. aligns the flag and the Text left
                      alignLeft: false,
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: TextField(
                        autofocus: false,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(8),
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Entrer votre numéro de téléphone",
                          hintStyle: TextStyle(
                            color: Color(0xff303030),
                            fontSize: 12,
                            fontFamily: currentFontFamily,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            telephone = value;
                          });
                        },
                        onSubmitted: (e) {
                          print(e.toString());
                          //Navigator.of(context).pushNamed(OtpPage.routeName);
                        },
                        keyboardType: TextInputType.number,
                      )),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          !isLoading
              ? Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: CustomButton(
                    color: Constants.primaryColor,
                    textColor: kWhite,
                    text: 'Se Connecter',
                    onPressed: () {
                      loginUser(context);
                    },
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: GestureDetector(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'En continuant, vous acceptez notre',
                      style: TextStyle(
                        color: Color(0xff303030),
                        fontSize: 12,
                        fontFamily: currentFontFamily,
                      ),
                    ),
                    TextSpan(
                        text: ' Condition générale d\'Utilisation',
                        style: TextStyle(
                          color: Color(0xff303030),
                          fontSize: 12,
                          fontFamily: currentFontFamily,
                          fontWeight: FontWeight.w700,
                        ),
                        onEnter: (e) {
                          print("Taped");
                        }),
                    TextSpan(
                      text: ' et ',
                      style: TextStyle(
                        color: Color(0xff303030),
                        fontSize: 12,
                        fontFamily: currentFontFamily,
                      ),
                    ),
                    TextSpan(
                        text: 'Politique de confidentialité',
                        style: TextStyle(
                          color: Color(0xff303030),
                          fontSize: 12,
                          fontFamily: currentFontFamily,
                          fontWeight: FontWeight.w700,
                        ),
                        onEnter: (e) {
                          print("Taped");
                        }),
                  ],
                ),
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loginUser(BuildContext context) async {
    if (telephone == "") {
      _showAlertDialog(
          'Désolé', 'Veuillez SVP renseigner les informations.', context);
    } else {
      setState(() {
        isLoading = true;
      });
      String phone = indicatif + telephone;
      print(phone);
      final response = await http.post(
          Uri.parse(
              Constants.host + "/api/auth/login?token=" + Constants.token),
          body: {'telephone': phone});
      print(response.body);
      var dataUser = json.decode(response.body);
      if (dataUser['error'] == true) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return ChooseProfileScreen(phone, pays);
        }));
      } else {
        print(dataUser['message']);
        print(dataUser['user']);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return PasswordScreen(phone, pays);
        }));
      }
    }
  }

  void _showAlertDialog(String title, String content, BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }
}
