import 'dart:io';

import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:allojobstogo/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  ProfileScreenState();

  String idUser = "";

  Future<String> nom = SharedPreferencesHelper.getValue("nom");
  Future<String> prenoms = SharedPreferencesHelper.getValue("prenoms");
  Future<String> quartier = SharedPreferencesHelper.getValue("quartier");
  Future<String> ville = SharedPreferencesHelper.getValue("ville");
  Future<String> description = SharedPreferencesHelper.getValue("description");
  Future<String> lastExperience =
      SharedPreferencesHelper.getValue("last_experience");
  Future<String> job = SharedPreferencesHelper.getValue("job");
  Future<String> lastDiplome = SharedPreferencesHelper.getValue("last_diplome");
  Future<String> email = SharedPreferencesHelper.getValue("email");
  Future<String> avatar = SharedPreferencesHelper.getValue("avatar");
  Future<int> id = SharedPreferencesHelper.getIntValue("id");

  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _jobController = TextEditingController();
  final _emailController = TextEditingController();
  final _quartierController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lastExperienceController = TextEditingController();
  final _lastDiplomeController = TextEditingController();
  final _villeController = TextEditingController();

  bool isLoading = false;

  var _image;
  String img64 = "";
  String myAvatar = "/avatars/default.png";

  GlobalKey<FormState> keyForm = GlobalKey();

  @override
  void initState() {
    id.then((int value) async {
      setState(() {
        idUser = value.toString();
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
    prenoms.then((String value) async {
      //
      setState(() {
        _firstNameController.text = value;
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
    description.then((String value) async {
      //
      setState(() {
        _descriptionController.text = value;
      });
    });
    job.then((String value) async {
      //
      setState(() {
        _jobController.text = value;
      });
    });
    lastExperience.then((String value) async {
      //
      setState(() {
        _lastExperienceController.text = value;
      });
    });
    lastDiplome.then((String value) async {
      //
      setState(() {
        _lastDiplomeController.text = value;
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

  Widget firstTab(largeur, hauteur) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: keyForm,
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
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
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
              hint: "Nom",
              type: TextInputType.text,
              controller: _lastNameController,
              maxLength: 25,
            ),
            CustomInput(
              hint: "Prénoms",
              type: TextInputType.text,
              controller: _firstNameController,
              maxLength: 25,
            ),
            CustomInput(
              hint: "Adresse mail",
              type: TextInputType.text,
              controller: _emailController,
              maxLength: 45,
            ),
            const SizedBox(height: 5.0),
            CustomInput(
              hint: "Votre dernier diplôme",
              type: TextInputType.text,
              controller: _lastDiplomeController,
              maxLength: 45,
            ),
            const SizedBox(height: 5.0),
            TextField(
              maxLines: 4,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: currentFontFamily,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText:
                    "Décrivez votre dernière expérience ainsi que l'entreprise",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 1, color: Constants.primaryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              controller: _lastExperienceController,
              keyboardType: TextInputType.text,
              maxLength: 160,
            ),
            const SizedBox(height: 5.0),
            CustomInput(
              hint: "Intitulé du poste recherché",
              type: TextInputType.text,
              controller: _jobController,
              maxLength: 45,
            ),
            const SizedBox(height: 5.0),
            TextField(
              maxLines: 4,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: currentFontFamily,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: "Décrivez vous",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 1, color: Constants.primaryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              controller: _descriptionController,
              keyboardType: TextInputType.text,
              maxLength: 400,
            ),
            CustomInput(
              hint: "Ville",
              type: TextInputType.text,
              controller: _villeController,
              maxLength: 25,
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
                        updateUser(context);
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
        Scaffold(
          backgroundColor: Colors.transparent,
          body: firstTab(largeur, hauteur),
        )
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
      print(img64);
    });
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

  Future<void> updateUser(BuildContext context) async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final ville = _villeController.text.trim();
    final description = _descriptionController.text.trim();
    final job = _jobController.text.trim();
    final lastExperience = _lastExperienceController.text.trim();
    final email = _emailController.text.trim();

    final lastDiplome = _lastDiplomeController.text.trim();

    if (ville == "" ||
        lastName == "" ||
        firstName == "" ||
        description == "" ||
        email == "" ||
        job == "" ||
        lastExperience == "" ||
        lastDiplome == "") {
      _showAlertDialog(
          'Désolé', 'Veuillez renseigner toutes les informations.');
    } else {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
          Uri.parse(
              "${Constants.host}/api/auth/update-user?token=${Constants.token}"),
          body: {
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'biographie': description,
            'last_diplome': lastDiplome,
            'last_experience': lastExperience,
            'job': job,
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

        SharedPreferencesHelper.setValue(
            "telephone", dataUser['user']["telephone"]);
        SharedPreferencesHelper.setValue("nom", dataUser['user']["nom"]);
        SharedPreferencesHelper.setValue("avatar", dataUser['user']["avatar"]);

        SharedPreferencesHelper.setIntValue(
            "status", dataUser['user']["status"]);
        SharedPreferencesHelper.setValue(
            "quartier", dataUser['user']["quartier"]);
        SharedPreferencesHelper.setValue("ville", dataUser['user']["ville"]);
        SharedPreferencesHelper.setValue("email", dataUser['user']["email"]);
        SharedPreferencesHelper.setValue(
            "prenoms", dataUser['user']["prenoms"]);
        SharedPreferencesHelper.setValue(
            "last_diplome", dataUser['user']["last_diplome"]);
        SharedPreferencesHelper.setValue("job", dataUser['user']["job"]);
        SharedPreferencesHelper.setValue(
            "description", dataUser['user']["description"]);
        SharedPreferencesHelper.setValue(
            "last_experience", dataUser['user']["last_experience"]);
        SharedPreferencesHelper.setValue(
            "prenoms", dataUser['user']["prenoms"]);

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
