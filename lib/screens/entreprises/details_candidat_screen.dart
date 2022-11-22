import 'package:allojobstogo/models/candidats.dart';
import 'package:allojobstogo/screens/chat_screen.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/helper.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui' as ui;

class DetailsCandidatScreen extends StatefulWidget {
  late ModelCandidat candidat;
  DetailsCandidatScreen(this.candidat);
  @override
  _DetailsCandidatScreenState createState() =>
      _DetailsCandidatScreenState(this.candidat);
}

class _DetailsCandidatScreenState extends State<DetailsCandidatScreen> {
  late ModelCandidat candidat;
  _DetailsCandidatScreenState(this.candidat);

  String phone = "", idUser = "";
  Future<int> idF = SharedPreferencesHelper.getIntValue("id");

  int isMeetingA = 0;
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
              title: new Text(candidat.nom + " " + candidat.prenoms,
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
                                      Constants.host + candidat.avatar)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          child: (candidat.status == 1)
                              ? new Stack(children: <Widget>[
                                  Positioned(
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
                                              candidat.telephone.toString());
                                        },
                                      )),
                                  Positioned(
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
                                              candidat.id,
                                              candidat.nom +
                                                  " " +
                                                  candidat.prenoms,
                                              candidat.avatar);
                                        }));
                                      },
                                    ),
                                  )
                                ])
                              : Center()),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        candidat.biographie,
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
                            width: screenSize.width * 0.3,
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.user,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    candidat.nom,
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
                                    FontAwesomeIcons.user,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(candidat.prenoms,
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
                            width: screenSize.width * 0.3,
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.city,
                                    color: Colors.grey,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(candidat.ville,
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
                          Text("Poste recherché: " + candidat.job,
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                          Text("Dernier diplôme: " + candidat.lastDiplome,
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                          Text(candidat.lastExperience,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ))),
            ))
      ],
    );
  }
}
