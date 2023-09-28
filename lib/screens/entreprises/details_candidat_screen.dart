import 'package:allojobstogo/models/candidats.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui' as ui;

class DetailsCandidatScreen extends StatefulWidget {
  final ModelCandidat candidat;
  const DetailsCandidatScreen(this.candidat, {super.key});
  @override
  DetailsCandidatScreenState createState() => DetailsCandidatScreenState();
}

class DetailsCandidatScreenState extends State<DetailsCandidatScreen> {
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
            appBar: AppBar(
              title: Text("${widget.candidat.nom} ${widget.candidat.prenoms}",
                  style: const TextStyle(
                    color: Colors.white,
                    letterSpacing: 1,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: currentFontFamily,
                  ),
                  textAlign: TextAlign.left),
              centerTitle: false,
              elevation: 0.0,
              backgroundColor: Constants.primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            backgroundColor: Colors.transparent,
            body: SizedBox(
              height: screenSize.height,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                      child: ListView(
                    children: [
                      Container(
                          height: screenSize.height * .4,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: NetworkImage(
                                      Constants.host + widget.candidat.avatar)),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(30.0))),
                          child: (widget.candidat.status == 1)
                              ? Stack(children: <Widget>[
                                  Positioned(
                                      bottom: 7,
                                      left: -12,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(),
                                            backgroundColor: Colors.green),
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle),
                                          child: const FaIcon(
                                            FontAwesomeIcons.whatsapp,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        onPressed: () async {
                                          UrlLauncher.launchUrl(Uri.parse(
                                              "https://wa.me/${widget.candidat.telephone}"));
                                        },
                                      )),
                                  Positioned(
                                    bottom: 7,
                                    right: -12,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          backgroundColor: Colors.blue),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle),
                                        child: const FaIcon(
                                          FontAwesomeIcons.phone,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      onPressed: () async {
                                        String telephone = Uri.encodeComponent(
                                            widget.candidat.telephone
                                                .toString());
                                        UrlLauncher.launch('tel:$telephone');
                                      },
                                    ),
                                  )
                                ])
                              : const Center()),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.candidat.biographie,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Divider(
                        height: 20,
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: screenSize.width * 0.3,
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.user,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    widget.candidat.nom,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                          ),
                          Container(
                            color: Colors.grey,
                            width: 1,
                            height: 30,
                          ),
                          SizedBox(
                            width: screenSize.width * 0.3,
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.user,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(widget.candidat.prenoms,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                          Container(
                            color: Colors.grey,
                            width: 1,
                            height: 30,
                          ),
                          SizedBox(
                            width: screenSize.width * 0.3,
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.city,
                                    color: Colors.grey,
                                    size: 25,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(widget.candidat.ville,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
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
                          SizedBox(
                            width: screenSize.width * 0.75,
                            child: Text(
                                "Poste recherché: ${widget.candidat.job}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
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
                          SizedBox(
                            width: screenSize.width * 0.75,
                            child: Text(
                                "Dernier diplôme: ${widget.candidat.lastDiplome}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
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
                          SizedBox(
                            width: screenSize.width * 0.8,
                            child: Text(widget.candidat.lastExperience,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
                    ],
                  ))),
            ))
      ],
    );
  }
}
