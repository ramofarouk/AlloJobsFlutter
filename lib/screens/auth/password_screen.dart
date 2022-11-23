import 'dart:async';
import 'package:allojobstogo/screens/candidats/dashboard_screen.dart';
import 'package:allojobstogo/screens/entreprises/dashboard_entreprise_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:allojobstogo/screens/auth/forget_password_screen.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:allojobstogo/widgets/custom_widget.dart';

class PasswordScreen extends StatefulWidget {
  String telephone, pays;
  PasswordScreen(this.telephone, this.pays);

  @override
  _PasswordScreenState createState() =>
      _PasswordScreenState(this.telephone, this.pays);
}

class _PasswordScreenState extends State<PasswordScreen> {
  String telephone, pays;
  _PasswordScreenState(this.telephone, this.pays);

  final _passwordController = TextEditingController();
  bool isLoading = false;
  bool _passwordVisible = false;

  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
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
            height: hauteur,
            padding: EdgeInsets.symmetric(horizontal: largeur / 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _keyForm,
                  child: Container(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: largeur / 15,
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
                            "Tapez votre mot de passe",
                            style: TextStyle(
                              color: Color(0xff303030),
                              fontSize: 18,
                              fontFamily: currentFontFamily,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _passwordVisible,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: currentFontFamily,
                              fontSize: 19,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(kPaddingM),
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
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Constants.primaryColor),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            controller: _passwordController,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                child: Text("Mot de passe oublié?"),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ForgetPasswordScreen(telephone);
                                  }));
                                },
                              )
                            ],
                          ),
                          SizedBox(height: 30),
                          !isLoading
                              ? CustomButton(
                                  color: Constants.primaryColor,
                                  textColor: kWhite,
                                  text: 'Continuer',
                                  onPressed: () {
                                    final password =
                                        _passwordController.text.trim();

                                    if (password == "") {
                                      _showAlertDialog('Désolé',
                                          'Veuillez SVP entrer votre mot de passe.');
                                    } else {
                                      checkUser(password, context);
                                    }
                                  },
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
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

  void _showAlertDialog(String title, String content) {
    var alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  Future<void> checkUser(String password, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
        Uri.parse(Constants.host + "/api/auth/check?token=" + Constants.token),
        body: {'password': password, 'telephone': telephone});
    print(response.body);
    var dataUser = json.decode(response.body);
    if (dataUser['error'] == true) {
      setState(() {
        isLoading = false;
      });
      _showAlertDialog('Désolé', 'Mot de passe incorrect! Veuillez réessayer.');
    } else {
      setState(() {
        isLoading = false;
      });
      print(dataUser['message']);
      print(dataUser['user']);
      SharedPreferencesHelper.setValue(
          "telephone", dataUser['user']["telephone"]);
      SharedPreferencesHelper.setValue("nom", dataUser['user']["nom"]);
      SharedPreferencesHelper.setIntValue("status", dataUser['user']["status"]);
      SharedPreferencesHelper.setIntValue(
          "type_user", dataUser['user']["type_user"]);
      SharedPreferencesHelper.setIntValue("id", dataUser['user']["id"]);
      SharedPreferencesHelper.setValue("avatar", dataUser['user']["avatar"]);

      SharedPreferencesHelper.setIntValue("step_auth", 1);
      if (dataUser['user']["type_user"] == 1) {
        SharedPreferencesHelper.setValue(
            "prenoms", dataUser['user']["prenoms"]);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => DashboardScreen(0)),
            (Route<dynamic> route) => false);
      } else {
        SharedPreferencesHelper.setValue(
            "activite", dataUser['user']["activite"]);
        SharedPreferencesHelper.setValue(
            "description", dataUser['user']["description"]);
        SharedPreferencesHelper.setValue(
            "quartier", dataUser['user']["quartier"]);
        SharedPreferencesHelper.setValue("ville", dataUser['user']["ville"]);
        SharedPreferencesHelper.setValue("email", dataUser['user']["email"]);
        SharedPreferencesHelper.setValue(
            "date_debut", dataUser['user']["date_debut"]);
        SharedPreferencesHelper.setValue("job", dataUser['user']["job"]);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => DashboardEntrepriseScreen(0)),
            (Route<dynamic> route) => false);
      }
    }
  }
}
