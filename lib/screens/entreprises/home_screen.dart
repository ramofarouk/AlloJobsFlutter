import 'package:allojobstogo/loaders/loader1.dart';
import 'package:allojobstogo/models/candidats.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'details_candidat_screen.dart';

class HomeScreen extends StatefulWidget {
  final AnimationController _controller;
  HomeScreen(this._controller);
  @override
  _HomeScreenState createState() => _HomeScreenState(this._controller);
}

class _HomeScreenState extends State<HomeScreen> {
  late double _scale;
  final AnimationController _controller;

  _HomeScreenState(this._controller);

  String firstName = "";
  String lastName = "";
  String phone = "", idUser = "";

  Future<String> nom = SharedPreferencesHelper.getValue("nom");
  Future<String> prenoms = SharedPreferencesHelper.getValue("prenoms");
  Future<String> telephone = SharedPreferencesHelper.getValue("telephone");
  Future<int> id = SharedPreferencesHelper.getIntValue("id");

  List<ModelCandidat> listCandidats = [];
  bool isLoading = true;

  Future<Null> getDatas(int idUser) async {
    setState(() {
      listCandidats.clear();
      isLoading = true;
    });
    print("Getting datas");
    final responseData = await http.get(
        Uri.parse(Constants.host + "/api/candidats?token=" + Constants.token));
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      print(data);
      setState(() {
        for (var i in data) {
          listCandidats.add(ModelCandidat(
            i['id'],
            i['nom'],
            i['prenoms'],
            i['description'],
            i['avatar'],
            i['ville'],
            i['last_experience'],
            i['last_diplome'],
            i['job'],
            i['telephone'],
            i['status'],
          ));
        }

        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
    // actualize();
  }

  @override
  void initState() {
    id.then((int value) async {
      print(value);
      setState(() {
        getDatas(value);
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    _scale = 1 - _controller.value;
    return Stack(children: [
      Positioned(
        top: 5,
        child: Card(
          elevation: 6.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: screenSize.width * 0.97,
                    alignment: Alignment.center,
                    height: 50,
                    child: TextFormField(
                      //controller: _contactController,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: currentFontFamily,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 4),
                          hintText: "Nom complet ou Poste",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: currentFontFamily,
                          ),
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: Icon(
                                Icons.contacts,
                                color: Colors.black.withOpacity(0.5),
                              )),
                          suffix: GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: CircleAvatar(
                                radius: 15,
                                child: FaIcon(
                                  FontAwesomeIcons.paperPlane,
                                  size: 15,
                                ),
                              ),
                            ),
                            onTap: () {
                              //sendTo(context);
                            },
                          )),
                    )),
              ],
            ),
          ),
        ),
      ),
      !isLoading
          ? Container(
              margin: EdgeInsets.only(top: 50),
              height: screenSize.height * 0.7,
              width: screenSize.width,
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: ListView.builder(
                    itemCount: listCandidats.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 16),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final candidat = listCandidats[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return DetailsCandidatScreen(candidat);
                          }));
                        },
                        child: Card(
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      Constants.host + candidat.avatar),
                                  maxRadius: 30,
                                ),
                                title: Text(
                                  candidat.nom + " " + candidat.prenoms,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: ui.FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "Poste recherché: " +
                                      candidat.job.toUpperCase(),
                                  style: TextStyle(fontSize: 14),
                                ),
                              )),
                        ),
                      );
                    },
                  )))
          : Container(
              margin: EdgeInsets.only(top: 60),
              height: screenSize.height * 0.7,
              width: screenSize.width,
              child: Center(
                child: ColorLoader1(
                  radius: 40.0,
                  dotRadius: 10.0,
                ),
              ),
            )
    ]);
  }

  void _showAlertDialog(String title, String content) {
    var alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }
}
