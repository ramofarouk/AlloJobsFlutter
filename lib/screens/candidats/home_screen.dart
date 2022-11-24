import 'dart:io';

import 'package:allojobstogo/loaders/loader1.dart';
import 'package:allojobstogo/models/entreprises.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

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

  List<ModelEntreprise> listEntreprises = [];
  bool isLoading = true;

  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  var _myCv;
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
          if (int.parse(i['entreprise']['status']) == 1) {
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
              int.parse(i['entreprise']['status']),
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
              height: screenSize.height * 0.75,
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
                                        height: screenSize.height * .3,
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
                                          Container(
                                            width: screenSize.width * 0.75,
                                            child: Text(entreprise.description,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      new Divider(
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.green),
                                        child: Container(
                                          width: screenSize.width * 0.9,
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle),
                                          child: Text("SOUMETTRE MON CV"),
                                        ),
                                        onPressed: () async {
                                          _showPopUp(screenSize, entreprise);
                                        },
                                      )
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

  void _showAlertDialog(String title, String content) {
    var alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
    );
    showDialog(
        context: this.context, builder: (BuildContext context) => alertDialog);
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
              Constants.host + "/api/soumission/add?token=" + Constants.token),
          body: {
            'entreprise_id': entreprise.id.toString(),
            'cv': cv64,
            'user_id': idUser
          });
      print(response.body);
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
          _myCv = null;
        });
        print(dataUser['message']);
        print(dataUser['user']);

        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            isScrollControlled: true,
            isDismissible: false,
            context: this.context,
            builder: (context) {
              return Container(
                height: screenSize.height * 0.5,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
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
                          "Nous acheminons votre au recruteur. Seules les personnes sélectionnées seront contactées.",
                          style: TextStyle(color: Colors.black, fontSize: 20),
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
                            backgroundColor: MaterialStateProperty.all(
                                Constants.primaryColor)),
                        onPressed: () {
                          Navigator.of(context).pop(context);
                        },
                        child: Text(
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
    }
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
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 10),
                            blurRadius: 10),
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Soumettre mon CV",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          FocusScope.of(context).requestFocus(new FocusNode());
                          pickFile(context, screenSize, entreprise);
                        },
                        child: new DottedBorder(
                            dashPattern: [6, 3, 2, 3],
                            borderType: BorderType.RRect,
                            radius: Radius.circular(12),
                            padding: EdgeInsets.all(6),
                            color: Colors.grey,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              child: GestureDetector(
                                child: Container(
                                  height: 100,
                                  child: _myCvName == ""
                                      ? Center(
                                          child: Column(children: [
                                            SizedBox(height: 5),
                                            FaIcon(FontAwesomeIcons.fileUpload,
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
                                      .requestFocus(new FocusNode());
                                  pickFile(context, screenSize, entreprise);
                                },
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: Container(
                          width: screenSize.width * 0.9,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Text("VALIDER"),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          registerUser(screenSize, entreprise);
                        },
                      ),
                      SizedBox(
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

      final bytes = File(file.path).readAsBytesSync();

      setState(() {
        cv64 = base64Encode(bytes);
        print(cv64);
      });

      _showPopUp(screenSize, entreprise);

      /* print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);*/
    } else {
      print("No file selected");
    }
  }
}
