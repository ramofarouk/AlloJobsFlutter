import 'dart:io';

import 'package:allojobstogo/loaders/loader1.dart';
import 'package:allojobstogo/models/entreprises.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/helper.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
  String _myCvName = "";

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

  Future<void> getDatas(int idUser) async {
    setState(() {
      listEntreprises.clear();
      isLoading = true;
    });

    final responseData = await http.get(Uri.parse(
        "${Constants.host}/api/entreprises?token=${Constants.token}"));
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);

      setState(() {
        for (var i in data) {
          if (i['entreprise']['status'] == 1) {
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
      setState(() {
        phone = value;
      });
    });

    nom.then((String value) async {
      setState(() {
        lastName = value;
      });
    });
    prenoms.then((String value) async {
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
              height: Helper.getScreenHeight(context) * 0.8,
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
                                    height:
                                        Helper.getScreenHeight(context) * 0.6,
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.all(5),
                                    child: ListView(children: [
                                      Container(
                                        height:
                                            Helper.getScreenHeight(context) *
                                                .3,
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
                                      ),
                                      const Divider(
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        child: Container(
                                          width: screenSize.width * 0.9,
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle),
                                          child: const Text("SOUMETTRE MON CV"),
                                        ),
                                        onPressed: () async {
                                          _showPopUp(screenSize, entreprise);
                                        },
                                      )
                                    ]))));
                      })))
          : Container(
              margin: const EdgeInsets.only(top: 60),
              height: Helper.getScreenHeight(context) * 0.7,
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

  void _showAlertDialog(String title, String content) {
    var alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  Future<void> registerUser(screenSize, entreprise) async {
    if (cv64 == "") {
      _showAlertDialog('Désolé', 'Veuillez téléverser votre CV.');
    } else {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
          Uri.parse(
              "${Constants.host}/api/soumission/add?token=${Constants.token}"),
          body: {
            'entreprise_id': entreprise.id.toString(),
            'cv': cv64,
            'user_id': idUser
          });

      var dataUser = json.decode(response.body);

      if (dataUser['error'] == true) {
        setState(() {
          isLoading = false;
        });
        _showAlertDialog('Désolé', 'Erreur survenue lors de la soumission!');
      } else {
        setState(() {
          isLoading = false;
          cv64 = "";
          _myCvName = "";
        });

        _showSuccessPopup();
      }
    }
  }

  void _showSuccessPopup() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) {
          return SizedBox(
            height: Helper.getScreenHeight(context) * 0.5,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
                Image.asset(
                  "assets/images/success.png",
                  height: 150,
                  width: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                      "Nous acheminons votre soumission au recruteur. Seules les personnes sélectionnées seront contactées.",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(
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
                      Navigator.of(context).pop(context);
                    },
                    child: const Text(
                      "Fermer",
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

  void _showPopUp(screenSize, entreprise) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 10),
                            blurRadius: 10),
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        "Soumettre mon CV",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          FocusScope.of(context).requestFocus(FocusNode());
                          pickFile(context, screenSize, entreprise);
                        },
                        child: DottedBorder(
                            dashPattern: const [6, 3, 2, 3],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(12),
                            padding: const EdgeInsets.all(6),
                            color: Colors.grey,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: GestureDetector(
                                child: SizedBox(
                                  height: 100,
                                  child: _myCvName == ""
                                      ? const Center(
                                          child: Column(children: [
                                            SizedBox(height: 5),
                                            FaIcon(FontAwesomeIcons.fileArrowUp,
                                                size: 50, color: Colors.grey),
                                            SizedBox(height: 10),
                                            Text(
                                              "Votre CV",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ]),
                                        )
                                      : Center(
                                          child: Align(
                                          heightFactor: 1,
                                          widthFactor: 1.0,
                                          child: Text(_myCvName),
                                        )),
                                ),
                                onTap: () async {
                                  Navigator.pop(context);
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  pickFile(context, screenSize, entreprise);
                                },
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: Container(
                          width: screenSize.width * 0.9,
                          height: 50,
                          alignment: Alignment.center,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: const Text("VALIDER"),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          registerUser(screenSize, entreprise);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> pickFile(BuildContext context, screenSize, entreprise) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        _myCvName = file.name;
      });

      final bytes = File(file.path.toString()).readAsBytesSync();

      setState(() {
        cv64 = base64Encode(bytes);
      });

      _showPopUp(screenSize, entreprise);
    } else {
      print("No file selected");
    }
  }
}
