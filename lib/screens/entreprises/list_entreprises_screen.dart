import 'package:allojobstogo/loaders/loader1.dart';
import 'package:allojobstogo/models/entreprises.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ListEntreprisesScreen extends StatefulWidget {
  const ListEntreprisesScreen({super.key});
  @override
  ListEntreprisesScreenState createState() => ListEntreprisesScreenState();
}

class ListEntreprisesScreenState extends State<ListEntreprisesScreen> {
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
          if (i['entreprise']['status'] == 1) {
            print("he");
            listEntreprises.add(ModelEntreprise(
              i['id'],
              i['entreprise']['nom'],
              i['description'],
              i['entreprise']['avatar'],
              i['entreprise']['ville'],
              i['entreprise']['activite'],
              i['job'],
              i['entreprise']['telephone'],
              i['entreprise']['quartier'],
              i['date_debut'],
              i['entreprise']['status'],
            ));
          }
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
      setState(() {
        idUser = value.toString();
        getDatas(value);
      });
    });
    telephone.then((String value) async {
      //
      setState(() {
        phone = value;
      });
    });

    nom.then((String value) async {
      //
      setState(() {
        lastName = value;
      });
    });
    prenoms.then((String value) async {
      //
      setState(() {
        firstName = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Stack(children: [
      !isLoading
          ? Container(
              margin: const EdgeInsets.only(top: 5),
              height: screenSize.height * 0.72,
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
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    height: screenSize.height * 0.6,
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.all(5),
                                    child: ListView(children: [
                                      Container(
                                        height: screenSize.height * .30,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.fitWidth,
                                                image: NetworkImage(
                                                    Constants.host +
                                                        entreprise.avatar)),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30.0))),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        entreprise.nom,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Divider(
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SizedBox(
                                            width: screenSize.width * 0.38,
                                            child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  const FaIcon(
                                                    FontAwesomeIcons.layerGroup,
                                                    color: Colors.grey,
                                                    size: 15,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    entreprise.activite,
                                                    style: const TextStyle(
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
                                          SizedBox(
                                            width: screenSize.width * 0.28,
                                            child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  const FaIcon(
                                                    FontAwesomeIcons
                                                        .locationArrow,
                                                    color: Colors.grey,
                                                    size: 15,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(entreprise.quartier,
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ]),
                                          ),
                                          Container(
                                            color: Colors.grey,
                                            width: 1,
                                            height: 30,
                                          ),
                                          SizedBox(
                                            width: screenSize.width * 0.2,
                                            child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  const FaIcon(
                                                    FontAwesomeIcons
                                                        .locationArrow,
                                                    color: Colors.grey,
                                                    size: 15,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(entreprise.ville,
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ]),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.briefcase,
                                            color: Colors.grey,
                                            size: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                                "Poste recherché: ${entreprise.job}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.businessTime,
                                            color: Colors.grey,
                                            size: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              "Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(entreprise.dateDebut))}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const Divider(
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.briefcase,
                                            color: Colors.grey,
                                            size: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: screenSize.width * 0.75,
                                            child: Text(entreprise.description,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      )
                                    ]))));
                      })))
          : Container(
              margin: const EdgeInsets.only(top: 60),
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
                    shape: const CircleBorder(),
                    backgroundColor: Constants.thridColor),
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const FaIcon(
                    FontAwesomeIcons.arrowRight,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.bounceIn);
                  });
                },
              ))
          : const Center(),
      (_currentPage > 0)
          ? Positioned(
              bottom: 5,
              left: 5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Constants.secondaryColor),
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.bounceIn);
                  });
                },
              ))
          : const Center(),
    ]);
  }
}
