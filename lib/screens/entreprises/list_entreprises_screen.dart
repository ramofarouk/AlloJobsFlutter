import 'dart:io';

import 'package:allojobstogo/loaders/loader1.dart';
import 'package:allojobstogo/models/entreprises.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ListEntreprisesScreen extends StatefulWidget {
  final AnimationController _controller;
  ListEntreprisesScreen(this._controller);
  @override
  _ListEntreprisesScreenState createState() =>
      _ListEntreprisesScreenState(this._controller);
}

class _ListEntreprisesScreenState extends State<ListEntreprisesScreen> {
  late double _scale;
  final AnimationController _controller;

  _ListEntreprisesScreenState(this._controller);

  String firstName = "";
  String lastName = "";
  String phone = "", idUser = "";

  Future<String> nom = SharedPreferencesHelper.getValue("nom");
  Future<String> prenoms = SharedPreferencesHelper.getValue("prenoms");
  Future<String> telephone = SharedPreferencesHelper.getValue("telephone");
  Future<int> id = SharedPreferencesHelper.getIntValue("id");

  List<ModelEntreprise> listEntreprises = [];
  bool isLoading = true;

  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  var _myCv;
  String cv64 = "";

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Future<Null> getDatas(int idUser) async {
    setState(() {
      listEntreprises.clear();
      isLoading = true;
    });
    print("Getting datas");
    final responseData = await http.get(Uri.parse(
        Constants.host + "/api/entreprises?token=" + Constants.token));
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      print(data);
      setState(() {
        for (var i in data) {
          listEntreprises.add(ModelEntreprise(
            i['id'],
            i['nom'],
            i['description'],
            i['avatar'],
            i['ville'],
            i['activite'],
            i['job'],
            i['telephone'],
            i['quartier'],
            i['date_debut'],
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
        idUser = value.toString();
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
      !isLoading
          ? Container(
              margin: EdgeInsets.only(top: 5),
              height: screenSize.height * 0.7,
              width: screenSize.width,
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      allowImplicitScrolling: true,
                      itemCount: listEntreprises.length,
                      itemBuilder: (context, i) {
                        final entreprise = listEntreprises[i];
                        return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateX(_currentPage - i.toDouble())
                              ..rotateY(_currentPage - i.toDouble())
                              ..rotateZ(_currentPage - i.toDouble()),
                            child: Card(
                                elevation: 8,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    height: screenSize.height * 0.6,
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.all(5),
                                    child: ListView(children: [
                                      Container(
                                        height: screenSize.height * .35,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.fitWidth,
                                                image: NetworkImage(
                                                    Constants.host +
                                                        entreprise.avatar)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0))),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        entreprise.nom,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      new Divider(
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: screenSize.width * 0.38,
                                            child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.layerGroup,
                                                    color: Colors.grey,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    entreprise.activite,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ]),
                                          ),
                                          Container(
                                            color: Colors.grey,
                                            width: 1,
                                            height: 30,
                                          ),
                                          Container(
                                            width: screenSize.width * 0.28,
                                            child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons
                                                        .locationArrow,
                                                    color: Colors.grey,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(entreprise.quartier,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ]),
                                          ),
                                          Container(
                                            color: Colors.grey,
                                            width: 1,
                                            height: 30,
                                          ),
                                          Container(
                                            width: screenSize.width * 0.2,
                                            child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons
                                                        .locationArrow,
                                                    color: Colors.grey,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(entreprise.ville,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ]),
                                          ),
                                        ],
                                      ),
                                      new Divider(
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.briefcase,
                                            color: Colors.grey,
                                            size: 25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              "Poste recherché: " +
                                                  entreprise.job,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      new Divider(
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.businessTime,
                                            color: Colors.grey,
                                            size: 25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Date: " + entreprise.dateDebut,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      new Divider(
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                    ]))));
                      })))
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
            ),
      (_currentPage + 1 < listEntreprises.length)
          ? Positioned(
              bottom: 5,
              right: 5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), primary: Constants.thridColor),
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: FaIcon(
                    FontAwesomeIcons.arrowRight,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.bounceIn);
                  });
                },
              ))
          : Center(),
      (_currentPage > 0)
          ? Positioned(
              bottom: 5,
              left: 5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), primary: Constants.secondaryColor),
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _pageController.previousPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.bounceIn);
                  });
                },
              ))
          : Center(),
    ]);
  }
}
