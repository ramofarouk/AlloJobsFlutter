import 'dart:io';

import 'package:allojobstogo/loaders/loader1.dart';
import 'package:allojobstogo/models/candidats.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:allojobstogo/widgets/custom_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'details_candidat_screen.dart';

class ProfileSceen extends StatefulWidget {
  ProfileSceen();
  @override
  _ProfileSceenState createState() => _ProfileSceenState();
}

class _ProfileSceenState extends State<ProfileSceen> {
  _ProfileSceenState();

  String idUser = "";

  Future<String> nom = SharedPreferencesHelper.getValue("nom");
  Future<String> quartier = SharedPreferencesHelper.getValue("quartier");
  Future<String> ville = SharedPreferencesHelper.getValue("ville");
  Future<String> date_debut = SharedPreferencesHelper.getValue("date_debut");
  Future<String> activite = SharedPreferencesHelper.getValue("activite");
  Future<String> email = SharedPreferencesHelper.getValue("email");
  Future<String> job = SharedPreferencesHelper.getValue("job");
  Future<String> description = SharedPreferencesHelper.getValue("description");
  Future<String> avatar = SharedPreferencesHelper.getValue("avatar");
  Future<int> id = SharedPreferencesHelper.getIntValue("id");

  final _lastNameController = TextEditingController();
  final _activiteController = TextEditingController();
  final _emailController = TextEditingController();
  final _quartierController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _villeController = TextEditingController();
  final _posteController = TextEditingController();

  bool isLoading = false;

  var _image;
  String img64 = "";
  String myAvatar = "/avatars/default.png";

  @override
  void initState() {
    id.then((int value) async {
      print(value);
      setState(() {
        idUser = value.toString();
      });
    });
    email.then((String value) async {
      // print(value);
      setState(() {
        _emailController.text = value;
      });
    });

    nom.then((String value) async {
      // print(value);
      setState(() {
        _lastNameController.text = value;
      });
    });
    quartier.then((String value) async {
      // print(value);
      setState(() {
        _quartierController.text = value;
      });
    });
    ville.then((String value) async {
      // print(value);
      setState(() {
        _villeController.text = value;
      });
    });
    date_debut.then((String value) async {
      // print(value);
      setState(() {
        _dateController.text = value;
      });
    });
    activite.then((String value) async {
      // print(value);
      setState(() {
        _activiteController.text = value;
      });
    });
    job.then((String value) async {
      // print(value);
      setState(() {
        _posteController.text = value;
      });
    });
    description.then((String value) async {
      // print(value);
      setState(() {
        _descriptionController.text = value;
      });
    });
    avatar.then((String value) async {
      // print(value);
      setState(() {
        myAvatar = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return ListView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: [
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
          SizedBox(
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
          CustomInput(
            hint: "Début de service",
            type: TextInputType.text,
            controller: _dateController,
            maxLength: 45,
          ),
          Container(
            child: new GestureDetector(
              onTap: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                _showPicker(context);
              },
              child: new Center(
                  child: new Stack(
                children: <Widget>[
                  _image == null
                      ? CircleAvatar(
                          radius: largeur < hauteur ? largeur / 6 : hauteur / 6,
                          backgroundImage:
                              NetworkImage(Constants.host + myAvatar),
                          backgroundColor: Colors.white)
                      : new CircleAvatar(
                          radius: 80,
                          child: ClipOval(
                            child: Align(
                              heightFactor: 1,
                              widthFactor: 2.0,
                              child: new Image.file(_image),
                            ),
                          )),
                  Positioned(
                      bottom: -5,
                      right: -12,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: Constants.primaryColor),
                        child: Container(
                          width: 25,
                          height: 25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: FaIcon(
                            FontAwesomeIcons.camera,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _showPicker(context);
                        },
                      )),
                ],
              )),
            ),
          ),
          SizedBox(height: 5.0),
          Center(
              child: Text(
            "Votre logo ou photo du recruteur",
            textAlign: TextAlign.center,
            style: TextStyle(color: Constants.primaryColor, fontSize: 15),
          )),
          SizedBox(height: 10.0),
          CustomInput(
            hint: "Quel poste recherchez-vous?",
            type: TextInputType.text,
            controller: _posteController,
            maxLength: 45,
          ),
          SizedBox(height: 5.0),
          TextField(
            maxLines: 4,
            style: TextStyle(
              color: Colors.black,
              fontFamily: currentFontFamily,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: "Description",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Constants.primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            controller: _descriptionController,
            keyboardType: TextInputType.text,
            maxLength: 400,
          ),
          SizedBox(height: 10.0),
          !isLoading
              ? Container(
                  padding: EdgeInsets.all(5),
                  width: 120,
                  child: RaisedButton(
                    elevation: 5.0,
                    onPressed: () {
                      updateEntreprise(context);
                    },
                    padding: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Constants.primaryColor,
                    child: Text(
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
              : CircularProgressIndicator()
        ]);
  }

  onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    final ImagePicker _picker = ImagePicker();
    File val;

    final pickedFile = await _picker.getImage(
      source: source,
    );

    val = (await ImageCropper().cropImage(
      sourcePath: pickedFile!.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxHeight: 400,
      maxWidth: 400,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Constants.primaryColor,
        toolbarTitle: "AllôJobs",
      ),
    ))!;

    setState(() {
      _image = val;
    });

    final bytes = File(val.path).readAsBytesSync();

    setState(() {
      img64 = base64Encode(bytes);
      print(img64);
    });
    // print("cropper ${val.runtimeType}");
    //capturedImageFile(val.path);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Merci de mettre votre propre photo sinon \nvotre compte sera supprimé",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.all(5),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Téléverser une photo'),
                      onTap: () {
                        onImageButtonPressed(ImageSource.gallery,
                            context: context);
                        //_imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      onImageButtonPressed(ImageSource.camera,
                          context: context);
                      //_imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> updateEntreprise(BuildContext context) async {
    final lastName = _lastNameController.text.trim();
    final ville = _villeController.text.trim();
    final description = _descriptionController.text.trim();
    final activite = _activiteController.text.trim();
    final poste = _posteController.text.trim();
    final email = _emailController.text.trim();
    final quartier = _quartierController.text.trim();
    final dateDebut = _dateController.text.trim();

    if (ville == "" ||
        lastName == "" ||
        description == "" ||
        activite == "" ||
        poste == "" ||
        email == "" ||
        quartier == "") {
      _showAlertDialog(
          'Désolé', 'Veuillez renseigner toutes les informations.');
    } else {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
          Uri.parse(Constants.host +
              "/api/auth/update-entreprise?token=" +
              Constants.token),
          body: {
            'name': lastName,
            'email': email,
            'quartier': quartier,
            'date_debut': dateDebut,
            'activite': activite,
            'description': description,
            'poste': poste,
            'ville': ville,
            'avatar': img64,
            'user_id': idUser,
          });
      print(response.body);
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
        print(dataUser['message']);
        print(dataUser['user']);
        SharedPreferencesHelper.setValue(
            "telephone", dataUser['user']["telephone"]);
        SharedPreferencesHelper.setValue("nom", dataUser['user']["nom"]);
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
}
