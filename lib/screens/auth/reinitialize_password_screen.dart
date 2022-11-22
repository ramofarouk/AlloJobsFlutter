import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:allojobstogo/screens/auth/login_screen.dart';
import 'package:allojobstogo/utils/constants.dart';

class ReinitializePasswordScreen extends StatefulWidget {
  String phone;
  ReinitializePasswordScreen(this.phone);
  @override
  _ReinitializePasswordScreenState createState() =>
      _ReinitializePasswordScreenState(this.phone);
}

class _ReinitializePasswordScreenState
    extends State<ReinitializePasswordScreen> {
  String phone;
  _ReinitializePasswordScreenState(this.phone);
  final _passwordController = TextEditingController();
  final _passwordController2 = TextEditingController();
  bool isLoading = false;
  bool _passwordVisible = false;
  bool _passwordVisible2 = false;
  final _keyForm = GlobalKey<FormState>();

  Widget _buildPasswordInput() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: _passwordVisible,
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
        hintText: 'Mot de passe',
        hintStyle: TextStyle(
          color: kBlack.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: kBlack.withOpacity(0.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Constants.primaryColor,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      controller: _passwordController,
    );
  }

  Widget _buildPasswordConfirmInput() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: _passwordVisible2,
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
        hintText: 'Confirmation',
        hintStyle: TextStyle(
          color: kBlack.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: kBlack.withOpacity(0.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordVisible2 ? Icons.visibility : Icons.visibility_off,
            color: Constants.primaryColor,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible2 = !_passwordVisible2;
            });
          },
        ),
      ),
      controller: _passwordController2,
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

  Future<void> updatePassword(String password, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
        Uri.parse(Constants.host +
            "/api/auth/reinitialize-password?token=" +
            Constants.token),
        body: {'password': password, 'telephone': phone});
    print(response.body);
    var dataUser = json.decode(response.body);
    if (dataUser['error'] == true) {
      setState(() {
        isLoading = false;
      });
      _showAlertDialog('Désolé', 'Erreur survenue lors de la modification.');
    } else {
      setState(() {
        isLoading = false;
      });
      print(dataUser['message']);
      print(dataUser['user']);
      _showPopupAlert(context);
    }
  }

  void _showPopupAlert(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) {
          return Container(
            height: size.height * 0.5,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false);
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ],
                ),
                Image.asset(
                  "assets/images/success.png",
                  height: 150,
                  width: 150,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                      "Votre mot de passe a été bien réinitialisé. Veuillez vous connecter à présent.",
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Constants.primaryColor)),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false);
                    },
                    child: Text(
                      "Se Connecter maintenant",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
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
                                            "Créer un nouveau mot de passe sûr.",
                                            style:
                                                TextStyle(color: Colors.black),
                                            textAlign: TextAlign.center),
                                        SizedBox(height: 10),
                                        _buildPasswordInput(),
                                        SizedBox(height: 20),
                                        _buildPasswordConfirmInput(),
                                        SizedBox(height: 50),
                                        !isLoading
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: SizedBox(
                                                  height: 50,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        final password =
                                                            _passwordController
                                                                .text
                                                                .trim();
                                                        final confirm =
                                                            _passwordController2
                                                                .text
                                                                .trim();
                                                        if (password == "" ||
                                                            confirm == "") {
                                                          _showAlertDialog(
                                                              'Désolé',
                                                              'Veuillez SVP renseigner les informations.');
                                                        } else if (password !=
                                                            confirm) {
                                                          _showAlertDialog(
                                                              'Désolé',
                                                              'Mots de passes non identiques.');
                                                        } else {
                                                          updatePassword(
                                                              password,
                                                              context);
                                                        }
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "TERMINER",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          SizedBox(width: 20),
                                                          Icon(
                                                              Icons
                                                                  .chevron_right,
                                                              color:
                                                                  Colors.white),
                                                          SizedBox(width: 20),
                                                        ],
                                                      )),
                                                ),
                                              )
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                      ]))))
                    ]))));
  }
}
