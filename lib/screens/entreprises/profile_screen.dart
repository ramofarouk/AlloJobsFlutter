import 'dart:io';

import 'package:allojobstogo/loaders/loader1.dart';
import 'package:allojobstogo/models/offres.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:allojobstogo/widgets/custom_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  ProfileScreenState();

  String idUser = "";

  Future<String> nom = SharedPreferencesHelper.getValue("nom");
  Future<String> quartier = SharedPreferencesHelper.getValue("quartier");
  Future<String> ville = SharedPreferencesHelper.getValue("ville");
  Future<String> activite = SharedPreferencesHelper.getValue("activite");
  Future<String> email = SharedPreferencesHelper.getValue("email");
  Future<String> avatar = SharedPreferencesHelper.getValue("avatar");
  Future<int> id = SharedPreferencesHelper.getIntValue("id");

  final _lastNameController = TextEditingController();
  final _activiteController = TextEditingController();
  final _emailController = TextEditingController();
  final _quartierController = TextEditingController();

  final _descriptionController = TextEditingController();
  final _villeController = TextEditingController();
  final _posteController = TextEditingController();

  bool isLoading = false;

  bool isLoading2 = false;

  dynamic _image;
  String img64 = "";
  String myAvatar = "/avatars/default.png";

  List<ModelOffre> listOffres = [];

  String dateDebut = "";
  final format = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    id.then((int value) async {
      setState(() {
        idUser = value.toString();
        getOffres(idUser);
      });
    });
    email.then((String value) async {
      //
      setState(() {
        _emailController.text = value;
      });
    });

    nom.then((String value) async {
      //
      setState(() {
        _lastNameController.text = value;
      });
    });
    quartier.then((String value) async {
      //
      setState(() {
        _quartierController.text = value;
      });
    });
    ville.then((String value) async {
      //
      setState(() {
        _villeController.text = value;
      });
    });

    activite.then((String value) async {
      //
      setState(() {
        _activiteController.text = value;
      });
    });

    avatar.then((String value) async {
      //
      setState(() {
        myAvatar = value;
      });
    });
    super.initState();
  }

  Future<void> getOffres(String idUser) async {
    setState(() {
      listOffres.clear();
      isLoading2 = true;
    });

    final responseData = await http.get(Uri.parse(
        "${Constants.host}/api/offres/$idUser?token=${Constants.token}"));
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);

      setState(() {
        for (var i in data) {
          listOffres.add(ModelOffre(
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

        isLoading2 = false;
      });
    }
    setState(() {
      isLoading2 = false;
    });
  }

  Widget firstTab(largeur, hauteur) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: [
          GestureDetector(
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              _showPicker(context);
            },
            child: Center(
                child: Stack(
              children: <Widget>[
                _image == null
                    ? CircleAvatar(
                        radius: largeur < hauteur ? largeur / 6 : hauteur / 6,
                        backgroundImage:
                            NetworkImage(Constants.host + myAvatar),
                        backgroundColor: Colors.white)
                    : CircleAvatar(
                        radius: 80,
                        child: ClipOval(
                          child: Align(
                            heightFactor: 1,
                            widthFactor: 2.0,
                            child: Image.file(_image),
                          ),
                        )),
                Positioned(
                    bottom: -5,
                    right: -12,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Constants.primaryColor),
                      child: Container(
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: const FaIcon(
                          FontAwesomeIcons.camera,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _showPicker(context);
                      },
                    )),
              ],
            )),
          ),
          const SizedBox(height: 5.0),
          Center(
              child: Text(
            "Votre logo ou photo du recruteur",
            textAlign: TextAlign.center,
            style: TextStyle(color: Constants.primaryColor, fontSize: 15),
          )),
          const SizedBox(height: 5.0),
          CustomInput(
            hint: "Nom de la société",
            type: TextInputType.text,
            controller: _lastNameController,
            maxLength: 25,
          ),
          CustomInput(
            hint: "Adresse mail",
            type: TextInputType.text,
            controller: _emailController,
            maxLength: 30,
          ),
          Text(
            "Merci de fournir un email valide. Les CV recoltés y sont acheminés.",
            style: TextStyle(
                color: Constants.secondaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomInput(
            hint: "Secteur d'activité",
            type: TextInputType.text,
            controller: _activiteController,
            maxLength: 30,
          ),
          CustomInput(
            hint: "Ville",
            type: TextInputType.text,
            controller: _villeController,
            maxLength: 25,
          ),
          CustomInput(
            hint: "Quartier",
            type: TextInputType.text,
            controller: _quartierController,
            maxLength: 45,
          ),
          const SizedBox(height: 10.0),
          !isLoading
              ? Container(
                  padding: const EdgeInsets.all(5),
                  width: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      padding: const EdgeInsets.all(5.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Constants.primaryColor,
                    ),
                    onPressed: () {
                      updateEntreprise(context);
                    },
                    child: const Text(
                      'MODIFIER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: currentFontFamily,
                      ),
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }

  Widget secondTab(largeur, hauteur) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: !isLoading2
          ? (listOffres.isNotEmpty)
              ? SizedBox(
                  height: hauteur * 0.6,
                  width: largeur,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ListView.builder(
                        itemCount: listOffres.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 16),
                        itemBuilder: (context, index) {
                          final offre = listOffres[index];
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: ListTile(
                                    leading: CachedNetworkImage(
                                        width: 60,
                                        height: 60,
                                        imageUrl: Constants.host + offre.avatar,
                                        imageBuilder: (context,
                                                imageProvider) =>
                                            CircleAvatar(
                                              backgroundImage: imageProvider,
                                              maxRadius: 30,
                                            )),
                                    title: Text(
                                      offre.job.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: ui.FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      "Description: ${offre.description}\nDate de service: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(offre.dateDebut))}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  )),
                            ),
                          );
                        },
                      )))
              : Container(
                  alignment: Alignment.center,
                  height: hauteur * 0.6,
                  width: largeur,
                  child: const Text(
                    "Aucune offre publiée",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ))
          : Container(
              margin: const EdgeInsets.only(top: 60),
              height: hauteur * 0.7,
              width: largeur,
              child: Center(
                child: ColorLoader1(
                  radius: 40.0,
                  dotRadius: 10.0,
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          color: Constants.primaryColor,
        ),
        BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 6.0,
              sigmaY: 6.0,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
            )),
        DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Constants.primaryColor,
                  iconTheme: const IconThemeData(color: Colors.white),
                  title: TabBar(
                    labelColor: Colors.white,
                    indicatorWeight: 5,
                    indicatorColor: Constants.thridColor,
                    tabs: const [
                      Tab(
                        child: Text("Mon profil"),
                      ),
                      Tab(
                        child: Text("Annonces"),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Constants.thridColor,
                  onPressed: () {
                    _addOffre(largeur, hauteur);
                  },
                  child: const FaIcon(FontAwesomeIcons.circlePlus),
                ),
                backgroundColor: Colors.transparent,
                body: TabBarView(
                  children: [
                    firstTab(largeur, hauteur),
                    secondTab(largeur, hauteur),
                  ],
                )))
      ],
    );
  }

  onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: source,
    );

    // val = (await ImageCropper().cropImage(
    //   sourcePath: pickedFile!.path,
    //   aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    //   compressQuality: 100,
    //   maxHeight: 400,
    //   maxWidth: 400,
    //   compressFormat: ImageCompressFormat.jpg,
    //   androidUiSettings: AndroidUiSettings(
    //     toolbarColor: Constants.primaryColor,
    //     toolbarTitle: "AllôJobs",
    //   ),
    // ))!;

    setState(() {
      _image = File(pickedFile!.path);
    });

    final bytes = File(pickedFile!.path).readAsBytesSync();

    setState(() {
      img64 = base64Encode(bytes);
    });
    // print("cropper ${val.runtimeType}");
    //capturedImageFile(val.path);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    "Merci de mettre votre propre photo sinon \nvotre compte sera supprimé",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Téléverser une photo'),
                    onTap: () {
                      onImageButtonPressed(ImageSource.gallery,
                          context: context);
                      //_imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    onImageButtonPressed(ImageSource.camera, context: context);
                    //_imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> updateEntreprise(BuildContext context) async {
    final lastName = _lastNameController.text.trim();
    final ville = _villeController.text.trim();
    //final description = _descriptionController.text.trim();
    final activite = _activiteController.text.trim();
    //final poste = _posteController.text.trim();
    final email = _emailController.text.trim();
    final quartier = _quartierController.text.trim();
    //final dateDebut = _dateController.text.trim();

    if (ville == "" ||
        lastName == "" ||
        activite == "" ||
        email == "" ||
        quartier == "") {
      _showAlertDialog(
          'Désolé', 'Veuillez renseigner toutes les informations.');
    } else {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
          Uri.parse(
              "${Constants.host}/api/auth/update-entreprise?token=${Constants.token}"),
          body: {
            'name': lastName,
            'email': email,
            'quartier': quartier,
            'activite': activite,
            'ville': ville,
            'avatar': img64,
            'user_id': idUser,
          });

      var dataUser = json.decode(response.body);
      if (dataUser['error'] == true) {
        setState(() {
          isLoading = false;
        });
        _showAlertDialog('Désolé',
            'Erreur survenue lors du traitement! Veuillez réessayer.');
      } else {
        setState(() {
          isLoading = false;
        });

        SharedPreferencesHelper.setValue(
            "telephone", dataUser['user']["telephone"]);
        SharedPreferencesHelper.setValue("nom", dataUser['user']["nom"]);
        SharedPreferencesHelper.setValue(
            "activite", dataUser['user']["activite"]);

        SharedPreferencesHelper.setValue(
            "quartier", dataUser['user']["quartier"]);
        SharedPreferencesHelper.setValue("ville", dataUser['user']["ville"]);
        SharedPreferencesHelper.setValue("email", dataUser['user']["email"]);
        SharedPreferencesHelper.setIntValue(
            "status", dataUser['user']["status"]);
        SharedPreferencesHelper.setIntValue(
            "type_user", dataUser['user']["type_user"]);
        SharedPreferencesHelper.setIntValue("id", dataUser['user']["id"]);
        SharedPreferencesHelper.setValue("avatar", dataUser['user']["avatar"]);
        SharedPreferencesHelper.setIntValue("step_auth", 1);

        _showAlertDialog(
            'Félicitations', 'Vos informations ont été modifiées avec succès!');
      }
    }
  }

  void _showAlertDialog(String title, String content) {
    var alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  void _addOffre(double largeur, double hauteur) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Stack(children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      left: 10, top: 20 + 20, right: 10, bottom: 10),
                  margin: const EdgeInsets.only(top: 47),
                  width: largeur * 0.80,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 10),
                            blurRadius: 10),
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CustomInput(
                        hint: "Quel poste recherchez-vous?",
                        type: TextInputType.text,
                        controller: _posteController,
                        maxLength: 45,
                      ),
                      const SizedBox(height: 5.0),
                      DateTimeField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.event,
                            color: Colors.black,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Début de service",
                          hintStyle: TextStyle(fontFamily: currentFontFamily),
                          border: InputBorder.none,
                        ),
                        format: format,
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: DateTime.now(),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            setState(() {
                              dateDebut = date.toString();
                            });

                            return date;
                          } else {
                            setState(() {
                              dateDebut = currentValue.toString();
                            });
                            return currentValue;
                          }
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        maxLines: 4,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: currentFontFamily,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: "Description",
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Constants.primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        controller: _descriptionController,
                        keyboardType: TextInputType.text,
                        maxLength: 400,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Constants.primaryColor),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            side: BorderSide(
                                                color:
                                                    Constants.primaryColor)))),
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  addOffer(context);
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Text("AJOUTER",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: currentFontFamily,
                                        )),
                                  ],
                                ))),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40)),
                        child: Image.asset("assets/images/logo.png")),
                  ),
                ),
                Positioned(
                  right: 1,
                  top: 40,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Constants.thridColor,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      )),
                ),
              ]));
        });
  }

  Future<void> addOffer(BuildContext context) async {
    final description = _descriptionController.text.trim();

    final poste = _posteController.text.trim();

    if (description == "" || poste == "" || dateDebut == "") {
      _showAlertDialog(
          'Désolé', 'Veuillez renseigner toutes les informations.');
    } else {
      setState(() {
        isLoading2 = true;
      });
      final response = await http.post(
          Uri.parse(
              "${Constants.host}/api/offres/add?token=${Constants.token}"),
          body: {
            'date_debut': dateDebut,
            'description': description,
            'job': poste,
            'user_id': idUser,
          });

      var dataUser = json.decode(response.body);
      if (dataUser['error'] == true) {
        setState(() {
          isLoading2 = false;
        });
        _showAlertDialog('Désolé',
            'Erreur survenue lors du traitement! Veuillez réessayer.');
      } else {
        setState(() {
          isLoading2 = false;
        });

        getOffres(idUser);

        _showAlertDialog(
            'Félicitations', 'Nouvelle offre ajoutée avec succès!');
      }
    }
  }
}
