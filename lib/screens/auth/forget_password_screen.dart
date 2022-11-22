import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:allojobstogo/widgets/custom_widget.dart';
import 'package:allojobstogo/widgets/header_widget.dart';

import 'reinitialize_password_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  String phone;
  ForgetPasswordScreen(this.phone);
  @override
  _ForgetPasswordScreenState createState() =>
      _ForgetPasswordScreenState(this.phone);
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  String phone;
  _ForgetPasswordScreenState(this.phone);
  final _codeController = TextEditingController();
  bool isLoading = false;
  String codeReally = "";
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    codeReally = Constants.getRandomInt(6);
    print(codeReally);
    sendCode();
    super.initState();
  }

  Widget _buildCodeInput() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: Colors.black,
        fontFamily: currentFontFamily,
        fontSize: 19,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(kPaddingM),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.12),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.12),
          ),
        ),
        hintText: 'Code de vérification',
        hintStyle: TextStyle(
          color: kBlack.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.check_box,
          color: kBlack.withOpacity(0.5),
        ),
      ),
      controller: _codeController,
    );
  }

  void _showAlertDialog(String title, String content) {
    var alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  Future<void> checkCode(String code, BuildContext context) async {
    if (code == codeReally) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ReinitializePasswordScreen(phone);
      }));
    } else {
      _showAlertDialog('Désolé', 'Code erroné.');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    final mQ = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
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
                height: mQ.height,
                padding: EdgeInsets.symmetric(horizontal: mQ.width / 15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                          key: _keyForm,
                          child: Container(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: mQ.width / 15,
                                  ),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              "assets/images/header.png"),
                                          width: 200.0,
                                          height: 200.0,
                                        ),
                                        Text(
                                            "Un code vous a été envoyé par sms. Veuillez le confirmer pour continuer",
                                            style:
                                                TextStyle(color: Colors.black),
                                            textAlign: TextAlign.center),
                                        SizedBox(height: 10),
                                        _buildCodeInput(),
                                        SizedBox(height: 30),
                                        !isLoading
                                            ? CustomButton(
                                                color: Constants.primaryColor,
                                                textColor: kWhite,
                                                text: 'Confirmer',
                                                onPressed: () {
                                                  final code = _codeController
                                                      .text
                                                      .trim();

                                                  if (code == "") {
                                                    _showAlertDialog('Désolé',
                                                        'Veuillez saisir un code!');
                                                  } else {
                                                    checkCode(code, context);
                                                  }
                                                },
                                              )
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                      ]))))
                    ]))));
  }

  Future<void> sendCode() async {
    final response = await http.post(
        Uri.parse(Constants.host +
            "/api/auth/send-code-sms?token=" +
            Constants.token),
        body: {'telephone': phone, 'code': codeReally});
    print(response.body);
  }
}
