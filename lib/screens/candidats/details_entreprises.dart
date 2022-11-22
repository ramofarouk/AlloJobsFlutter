import 'dart:convert';
import 'dart:io';

import 'package:allojobstogo/models/entreprises.dart';
import 'package:allojobstogo/models/entreprises.dart';
import 'package:allojobstogo/screens/chat_screen.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui' as ui;

class DetailsEntrepriseScreen extends StatefulWidget {
  late ModelEntreprise entreprise;
  DetailsEntrepriseScreen(this.entreprise);
  @override
  _DetailsEntrepriseScreenState createState() =>
      _DetailsEntrepriseScreenState(this.entreprise);
}

class _DetailsEntrepriseScreenState extends State<DetailsEntrepriseScreen> {
  late ModelEntreprise entreprise;
  _DetailsEntrepriseScreenState(this.entreprise);

  String phone = "", idUser = "";
  Future<int> idF = SharedPreferencesHelper.getIntValue("id");

  var _myCv;
  String cv64 = "";

  @override
  void initState() {
    idF.then((int value) async {
      // print(value);
      setState(() {
        idUser = value.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return new Stack(
      children: <Widget>[
        new Container(
          color: Constants.primaryColor,
        ),
        new BackdropFilter(
            filter: new ui.ImageFilter.blur(
              sigmaX: 6.0,
              sigmaY: 6.0,
            ),
            child: new Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
            )),
        new Scaffold(
            appBar: new AppBar(
              title: new Text(entreprise.nom,
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: currentFontFamily,
                  ),
                  textAlign: TextAlign.left),
              centerTitle: false,
              elevation: 0.0,
              backgroundColor: Constants.primaryColor,
              iconTheme: IconThemeData(color: Colors.white),
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            backgroundColor: Colors.transparent,
            body: new Container(
              height: screenSize.height,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                      child: ListView(
                    children: [
                      Container(
                          height: screenSize.height * .4,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: NetworkImage(
                                      Constants.host + entreprise.avatar)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          child: (entreprise.status == 1)
                              ? new Stack(children: <Widget>[
                                  /*Positioned(
                                      bottom: 7,
                                      left: -12,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            primary: Colors.green),
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle),
                                          child: FaIcon(
                                            FontAwesomeIcons.whatsapp,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        onPressed: () async {
                                          UrlLauncher.launch("https://wa.me/" +
                                              entreprise.telephone.toString());
                                        },
                                      )),*/
                                  /* Positioned(
                                    bottom: 7,
                                    right: -12,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: CircleBorder(),
                                          primary: Colors.blue),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle),
                                        child: FaIcon(
                                          FontAwesomeIcons.comments,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ChatDetailsScreen(
                                              int.parse(idUser),
                                              entreprise.id,
                                              entreprise.nom,
                                              entreprise.avatar);
                                        }));
                                      },
                                    ),
                                  )*/
                                ])
                              : Center()),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        entreprise.description,
                        style: TextStyle(fontSize: 18),
                      ),
                      new Divider(
                        height: 20,
                        color: Colors.grey,
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: screenSize.width * 0.4,
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.building,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    entreprise.nom,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ]),
                          ),
                          Container(
                            color: Colors.grey,
                            width: 1,
                            height: 30,
                          ),
                          Container(
                            width: screenSize.width * 0.3,
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.layerGroup,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(entreprise.activite,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
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
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.locationArrow,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(entreprise.ville,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
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
                          Text("Poste recherché: " + entreprise.job,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      new Divider(
                        height: 20,
                        color: Colors.grey,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: Container(
                          width: screenSize.width * 0.9,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Text("SOUMETTRE MON CV"),
                        ),
                        onPressed: () async {
                          _showPopUp(screenSize);
                        },
                      )
                    ],
                  ))),
            ))
      ],
    );
  }

  void _showPopUp(screenSize) {
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
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _showPickerCV(context);
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
                                  child: _myCv == null
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
                                          child: new Image.file(_myCv),
                                        )),
                                ),
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  _showPickerCV(context);
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
                        onPressed: () async {},
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
}
