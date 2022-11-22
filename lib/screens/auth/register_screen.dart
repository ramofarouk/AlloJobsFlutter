import 'dart:io';

import 'package:allojobstogo/screens/entreprises/dashboard_entreprise_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:allojobstogo/widgets/custom_widget.dart';
import 'dart:convert';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../candidats/dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  int typeUser;
  String telephone, pays;
  RegisterScreen(this.typeUser, this.telephone, this.pays);

  @override
  _RegisterScreenState createState() =>
      _RegisterScreenState(this.typeUser, this.telephone, this.pays);
}

class _RegisterScreenState extends State<RegisterScreen> {
  int typeUser;
  String telephone, pays;
  _RegisterScreenState(this.typeUser, this.telephone, this.pays);
  bool isLoading = false;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _activiteController = TextEditingController();
  final _emailController = TextEditingController();
  final _quartierController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _biographieController = TextEditingController();
  final _lastDiplomeController = TextEditingController();
  final _lastExperienceController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _villeController = TextEditingController();
  final _posteController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordController2 = TextEditingController();
  bool _passwordVisible = false;
  bool _passwordVisible2 = false;

  var _image, _myCv;
  String img64 = "";
  String cv64 = "";
  String myAvatar = "/avatars/default.png";

  int currentStep = 0;
  int countStep = 3;

  @override
  void initState() {
    if (typeUser == 1) {
      setState(() {
        countStep = 3;
      });
    }
    super.initState();
  }

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
            margin: EdgeInsets.only(top: 50),
            padding: EdgeInsets.all(10),
            child: Stepper(
              type: StepperType.vertical,
              currentStep: currentStep,
              elevation: 10,
              controlsBuilder: (context, details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    (details.currentStep > 0)
                        ? Container(
                            padding: EdgeInsets.all(5),
                            width: 100,
                            child: RaisedButton(
                              elevation: 5.0,
                              onPressed: details.onStepCancel,
                              padding: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.red,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.arrowAltCircleLeft,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Retour',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: currentFontFamily,
                                      ),
                                    )
                                  ]),
                            ),
                          )
                        : Center(),
                    !isLoading
                        ? Container(
                            padding: EdgeInsets.all(5),
                            width: 120,
                            child: RaisedButton(
                              elevation: 5.0,
                              onPressed: details.onStepContinue,
                              padding: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.green,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (details.currentStep == countStep - 1)
                                          ? 'Terminer'
                                          : 'Continuer',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: currentFontFamily,
                                      ),
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.arrowAltCircleRight,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ]),
                            ),
                          )
                        : CircularProgressIndicator(),
                  ],
                );
              },
              onStepCancel: () => currentStep == 0
                  ? null
                  : setState(() {
                      currentStep -= 1;
                    }),
              onStepContinue: () {
                bool isLastStep = (currentStep ==
                    ((typeUser == 2)
                                ? getStepsEntreprise(hauteur, largeur)
                                : getStepsCandidats(hauteur, largeur))
                            .length -
                        1);
                if (isLastStep) {
                  if (typeUser == 1) {
                    registerUser(context);
                  } else {
                    registerEntreprise(context);
                  }
                } else {
                  setState(() {
                    currentStep += 1;
                  });
                }
              },
              onStepTapped: (step) => setState(() {
                currentStep = step;
              }),
              steps: (typeUser == 2)
                  ? getStepsEntreprise(hauteur, largeur)
                  : getStepsCandidats(hauteur, largeur),
            )),
      ),
    );
  }

  List<Step> getStepsEntreprise(hauteur, largeur) {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text("Informations principales"),
        content: Card(
            elevation: 10,
            child: Padding(
              child: Column(
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
                    maxLength: 25,
                  ),
                  CustomInput(
                    hint: "Début de service",
                    type: TextInputType.text,
                    controller: _dateController,
                    maxLength: 25,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
            )),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text("Informations complémentaires"),
        content: Card(
            elevation: 10,
            child: Padding(
              child: Column(
                children: [
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
                                  radius: largeur < hauteur
                                      ? largeur / 6
                                      : hauteur / 6,
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
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: FaIcon(
                                    FontAwesomeIcons.camera,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                onPressed: () async {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
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
                    style:
                        TextStyle(color: Constants.primaryColor, fontSize: 17),
                  )),
                  SizedBox(height: 10.0),
                  CustomInput(
                    hint: "Quel poste recherchez-vous?",
                    type: TextInputType.text,
                    controller: _posteController,
                    maxLength: 25,
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
                        borderSide:
                            BorderSide(width: 1, color: Constants.primaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    controller: _descriptionController,
                    keyboardType: TextInputType.text,
                    maxLength: 400,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
            )),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text("Mot de passe"),
        content: Card(
            elevation: 10,
            child: Padding(
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _passwordVisible,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: currentFontFamily,
                      fontSize: 15,
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
                      hintText: 'Créer un mot de passe',
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
                          color: Constants.primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    controller: _passwordController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _passwordVisible2,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: currentFontFamily,
                      fontSize: 15,
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
                          _passwordVisible2
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Constants.primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible2 = !_passwordVisible2;
                          });
                        },
                      ),
                    ),
                    controller: _passwordController2,
                  )
                ],
              ),
              padding: EdgeInsets.all(10),
            )),
      ),
    ];
  }

  List<Step> getStepsCandidats(hauteur, largeur) {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text("Informations personnelles"),
        content: Card(
            elevation: 10,
            child: Padding(
              child: Column(
                children: [
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
                    hint: "Ville",
                    type: TextInputType.text,
                    controller: _villeController,
                    maxLength: 25,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
            )),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text("Informations Professionelles"),
        content: Card(
            elevation: 10,
            child: Padding(
              child: Column(
                children: [
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
                                  radius: largeur < hauteur
                                      ? largeur / 6
                                      : hauteur / 6,
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
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: FaIcon(
                                    FontAwesomeIcons.camera,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                onPressed: () async {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
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
                    "Charger votre photo",
                    style:
                        TextStyle(color: Constants.primaryColor, fontSize: 17),
                  )),
                  SizedBox(height: 10.0),
                  CustomInput(
                    hint: "Adresse mail",
                    type: TextInputType.text,
                    controller: _emailController,
                    maxLength: 25,
                  ),
                  SizedBox(height: 5.0),
                  CustomInput(
                    hint: "Votre dernier diplôme",
                    type: TextInputType.text,
                    controller: _lastDiplomeController,
                    maxLength: 25,
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
                      hintText:
                          "Décrivez votre dernière expérience ainsi que l'entreprise",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Constants.primaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    controller: _lastExperienceController,
                    keyboardType: TextInputType.text,
                    maxLength: 160,
                  ),
                  SizedBox(height: 5.0),
                  CustomInput(
                    hint: "Intitulé du poste recherché",
                    type: TextInputType.text,
                    controller: _jobTitleController,
                    maxLength: 25,
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
                      hintText: "Décrivez vous",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Constants.primaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    controller: _biographieController,
                    keyboardType: TextInputType.text,
                    maxLength: 400,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
            )),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text("Mot de passe"),
        content: Card(
            elevation: 10,
            child: Padding(
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _passwordVisible,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: currentFontFamily,
                      fontSize: 15,
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
                      hintText: 'Créer un mot de passe',
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
                          color: Constants.primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    controller: _passwordController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _passwordVisible2,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: currentFontFamily,
                      fontSize: 15,
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
                          _passwordVisible2
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Constants.primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible2 = !_passwordVisible2;
                          });
                        },
                      ),
                    ),
                    controller: _passwordController2,
                  )
                ],
              ),
              padding: EdgeInsets.all(10),
            )),
      ),
    ];
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Téléverser une photo'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showPickerCV(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Téléverser une photo'),
                      onTap: () {
                        _imgFromGalleryCni();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCameraCni();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    PickedFile? image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });

      final bytes = File(image.path).readAsBytesSync();

      setState(() {
        img64 = base64Encode(bytes);
        print(img64);
      });
    }
  }

  _imgFromGallery() async {
    PickedFile? image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });

      final bytes = File(image.path).readAsBytesSync();

      setState(() {
        img64 = base64Encode(bytes);
        print(img64);
      });
    }
  }

  _imgFromCameraCni() async {
    PickedFile? image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    if (image != null) {
      setState(() {
        _myCv = File(image.path);
      });

      final bytes = File(image.path).readAsBytesSync();

      setState(() {
        cv64 = base64Encode(bytes);
        print(cv64);
      });
    }
  }

  _imgFromGalleryCni() async {
    PickedFile? image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    if (image != null) {
      setState(() {
        _myCv = File(image.path);
      });

      final bytes = File(image.path).readAsBytesSync();

      setState(() {
        cv64 = base64Encode(bytes);
        print(cv64);
      });
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

  Future<void> registerUser(BuildContext context) async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final ville = _villeController.text.trim();
    final email = _emailController.text.trim();
    final lastDiplome = _lastDiplomeController.text.trim();
    final lastExperience = _lastExperienceController.text.trim();
    final jobTitle = _jobTitleController.text.trim();
    final biographie = _biographieController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _passwordController2.text.trim();
    if (firstName == "" ||
        ville == "" ||
        lastName == "" ||
        lastDiplome == "" ||
        lastExperience == "" ||
        jobTitle == "" ||
        biographie == "" ||
        email == "") {
      _showAlertDialog(
          'Désolé', 'Veuillez renseigner vos informations personnelles.');
    } else if (password == "" || confirm == "") {
      _showAlertDialog('Désolé', 'Veuillez créer des mots de passes valides.');
    } else if (password != confirm) {
      _showAlertDialog('Désolé', 'Mots de passes non identiques.');
    } else {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
          Uri.parse(
              Constants.host + "/api/auth/register?token=" + Constants.token),
          body: {
            'first_name': firstName,
            'last_name': lastName,
            'password': password,
            'email': email,
            'biographie': biographie,
            'last_diplome': "last_diplome",
            'last_experience': "last_experience",
            'type_user': typeUser.toString(),
            'job': jobTitle,
            'pays': pays,
            'ville': ville,
            'avatar': img64,
            'cv': cv64,
            'telephone': telephone
          });
      print(response.body);
      var dataUser = json.decode(response.body);
      if (dataUser['error'] == true) {
        setState(() {
          isLoading = false;
        });
        _showAlertDialog('Désolé',
            'Erreur survenue lors de l\'inscription. Numéro déjà utilisé');
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
            "prenoms", dataUser['user']["prenoms"]);
        SharedPreferencesHelper.setIntValue(
            "status", dataUser['user']["status"]);
        SharedPreferencesHelper.setIntValue(
            "type_user", dataUser['user']["type_user"]);
        SharedPreferencesHelper.setIntValue("id", dataUser['user']["id"]);
        SharedPreferencesHelper.setValue("avatar", dataUser['user']["avatar"]);
        SharedPreferencesHelper.setIntValue("step_auth", 1);
        SharedPreferencesHelper.setValue("token", dataUser['user']["token"]);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => DashboardScreen(0)),
            (Route<dynamic> route) => false);
      }
    }
  }

  Future<void> registerEntreprise(BuildContext context) async {
    final lastName = _lastNameController.text.trim();
    final ville = _villeController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _passwordController2.text.trim();
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
          'Désolé', 'Veuillez renseigner vos informations personnelles.');
    } else if (password == "" || confirm == "") {
      _showAlertDialog('Désolé', 'Veuillez créer des mots de passes valides.');
    } else if (password != confirm) {
      _showAlertDialog('Désolé', 'Mots de passes non identiques.');
    } else {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
          Uri.parse(Constants.host +
              "/api/auth/register-entreprise?token=" +
              Constants.token),
          body: {
            'name': lastName,
            'password': password,
            'email': email,
            'pays': pays,
            'quartier': quartier,
            'date_debut': dateDebut,
            'activite': activite,
            'description': description,
            'poste': poste,
            'ville': ville,
            'avatar': img64,
            'type_user': typeUser.toString(),
            'telephone': telephone
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
        SharedPreferencesHelper.setIntValue(
            "status", dataUser['user']["status"]);
        SharedPreferencesHelper.setIntValue(
            "type_user", dataUser['user']["type_user"]);
        SharedPreferencesHelper.setIntValue("id", dataUser['user']["id"]);
        SharedPreferencesHelper.setValue("avatar", dataUser['user']["avatar"]);
        SharedPreferencesHelper.setValue("token", dataUser['user']["token"]);
        SharedPreferencesHelper.setIntValue("step_auth", 1);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => DashboardEntrepriseScreen(0)),
            (Route<dynamic> route) => false);
      }
    }
  }
}
