import 'dart:io';

import 'package:allojobstogo/screens/entreprises/dashboard_entreprise_screen.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:allojobstogo/widgets/custom_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';

import '../candidats/dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  final int typeUser;
  final String telephone, pays;
  const RegisterScreen(this.typeUser, this.telephone, this.pays, {super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
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

  dynamic _image;
  String img64 = "";
  String myAvatar = "/avatars/default.png";

  int currentStep = 0;
  int countStep = 3;

  @override
  void initState() {
    if (widget.typeUser == 1) {
      setState(() {
        countStep = 3;
      });
    }
    super.initState();
  }

  String dateDebut = "";
  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back1.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.linearToSrgbGamma(),
          ),
        ),
        child: Container(
            height: hauteur,
            margin: const EdgeInsets.only(top: 50),
            padding: const EdgeInsets.all(10),
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
                            padding: const EdgeInsets.all(5),
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5.0,
                                padding: const EdgeInsets.all(5.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Colors.red,
                              ),
                              onPressed: details.onStepCancel,
                              child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.circleLeft,
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
                        : const Center(),
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
                                backgroundColor: Colors.green,
                              ),
                              onPressed: details.onStepContinue,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (details.currentStep == countStep - 1)
                                          ? 'Terminer'
                                          : 'Continuer',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: currentFontFamily,
                                      ),
                                    ),
                                    const FaIcon(
                                      FontAwesomeIcons.circleRight,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ]),
                            ),
                          )
                        : const CircularProgressIndicator(),
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
                    ((widget.typeUser == 2)
                                ? getStepsEntreprise(hauteur, largeur)
                                : getStepsCandidats(hauteur, largeur))
                            .length -
                        1);
                if (isLastStep) {
                  if (widget.typeUser == 1) {
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
              steps: (widget.typeUser == 2)
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
              padding: const EdgeInsets.all(10),
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
                  DateTimeField(
                    decoration: const InputDecoration(
                        hintText: "Début de service",
                        border: OutlineInputBorder()),
                    format: format,
                    controller: _dateController,
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
                ],
              ),
            )),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text("Informations complémentaires"),
        content: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
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
                                radius: largeur < hauteur
                                    ? largeur / 6
                                    : hauteur / 6,
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
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
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
                    style:
                        TextStyle(color: Constants.primaryColor, fontSize: 15),
                  )),
                  const SizedBox(height: 10.0),
                  CustomInput(
                    hint: "Quel poste recherchez-vous?",
                    type: TextInputType.text,
                    controller: _posteController,
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
                      hintText: "Description",
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Constants.primaryColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    controller: _descriptionController,
                    keyboardType: TextInputType.text,
                    maxLength: 400,
                  ),
                ],
              ),
            )),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text("Mot de passe"),
        content: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _passwordVisible,
                    style: const TextStyle(
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
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _passwordVisible2,
                    style: const TextStyle(
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
              padding: const EdgeInsets.all(10),
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
            )),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text("Informations Professionelles"),
        content: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
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
                                radius: largeur < hauteur
                                    ? largeur / 6
                                    : hauteur / 6,
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
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _showPicker(context);
                              },
                            )),
                      ],
                    )),
                  ),
                  const SizedBox(height: 5.0),
                  Center(
                      child: Text(
                    "Charger votre photo",
                    style:
                        TextStyle(color: Constants.primaryColor, fontSize: 17),
                  )),
                  const SizedBox(height: 10.0),
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
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Constants.primaryColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
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
                    controller: _jobTitleController,
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
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Constants.primaryColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    controller: _biographieController,
                    keyboardType: TextInputType.text,
                    maxLength: 400,
                  ),
                ],
              ),
            )),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text("Mot de passe"),
        content: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _passwordVisible,
                    style: const TextStyle(
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
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _passwordVisible2,
                    style: const TextStyle(
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
            )),
      ),
    ];
  }

  onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: source,
    );

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                  child: Text(
                    "Merci de mettre votre propre photo sinon \nvotre compte sera supprimé",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.secondaryColor),
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
          'Désolé', 'Veuillez renseigner toutes vos informations.');
    } else if (password == "" || confirm == "") {
      _showAlertDialog('Désolé', 'Veuillez créer des mots de passes valides.');
    } else if (img64 == "") {
      _showAlertDialog('Désolé', 'Veuillez téléverser votre photo');
    } else if (password != confirm) {
      _showAlertDialog('Désolé', 'Mots de passes non identiques.');
    } else {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
          Uri.parse(
              "${Constants.host}/api/auth/register?token=${Constants.token}"),
          body: {
            'first_name': firstName,
            'last_name': lastName,
            'password': password,
            'email': email,
            'biographie': biographie,
            'last_diplome': lastDiplome,
            'last_experience': lastExperience,
            'type_user': widget.typeUser.toString(),
            'job': jobTitle,
            'pays': widget.pays,
            'ville': ville,
            'avatar': img64,
            'cv': "",
            'telephone': widget.telephone
          });

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

        SharedPreferencesHelper.setValue(
            "telephone", dataUser['user']["telephone"]);
        SharedPreferencesHelper.setValue("nom", dataUser['user']["nom"]);

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
        SharedPreferencesHelper.setIntValue(
            "type_user", dataUser['user']["type_user"]);
        SharedPreferencesHelper.setIntValue("id", dataUser['user']["id"]);
        SharedPreferencesHelper.setValue("avatar", dataUser['user']["avatar"]);
        SharedPreferencesHelper.setIntValue("step_auth", 1);
        SharedPreferencesHelper.setValue("token", dataUser['user']["token"]);

        moveToDashboard();
      }
    }
  }

  moveToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const DashboardScreen(0)),
        (Route<dynamic> route) => false);
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
          'Désolé', 'Veuillez renseigner toutes les informations.');
    } else if (img64 == "") {
      _showAlertDialog('Désolé', 'Veuillez téléverser votre photo');
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
              "${Constants.host}/api/auth/register-entreprise?token=${Constants.token}"),
          body: {
            'name': lastName,
            'password': password,
            'email': email,
            'pays': widget.pays,
            'quartier': quartier,
            'date_debut': dateDebut,
            'activite': activite,
            'description': description,
            'poste': poste,
            'ville': ville,
            'avatar': img64,
            'type_user': widget.typeUser.toString(),
            'telephone': widget.telephone
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
        SharedPreferencesHelper.setValue("token", dataUser['user']["token"]);
        SharedPreferencesHelper.setIntValue("step_auth", 1);

        _showPopupAlert();
      }
    }
  }

  void _showPopupAlert() {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) {
          return SizedBox(
            height: size.height * 0.5,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DashboardEntrepriseScreen(0)),
                            (Route<dynamic> route) => false);
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
                      "Votre annonce est  bien enregistrée et sera validée dans les 24h ouvrables. Nous pouvons être amenés à vous appeler.",
                      style: TextStyle(color: Colors.black),
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
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const DashboardEntrepriseScreen(0)),
                          (Route<dynamic> route) => false);
                    },
                    child: const Text(
                      "Accéder au tableau de bord",
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
