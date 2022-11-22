import 'package:allojobstogo/models/messages.dart';
import 'package:allojobstogo/utils/constants.dart';
import 'package:allojobstogo/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ChatDetailsScreen extends StatefulWidget {
  int idUser;
  int idContact;
  String pseudo, avatar;
  ChatDetailsScreen(this.idUser, this.idContact, this.pseudo, this.avatar);
  @override
  _ChatDetailsScreenState createState() => _ChatDetailsScreenState(
      this.idUser, this.idContact, this.pseudo, this.avatar);
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  int idUser;
  int idContact;
  String pseudo, avatar;
  _ChatDetailsScreenState(
      this.idUser, this.idContact, this.pseudo, this.avatar);

  final _messageController = TextEditingController();
  ScrollController controllerListView = new ScrollController();

  var loading = true;
  var isLoading = true;
  List<ModelChatMessage> listMessages = [];
  late Timer timerRequest;
  DateFormat dateformat = DateFormat("yyyy-MM-dd HH:mm:ss");

  Future<Null> getDatas() async {
    listMessages.clear();
    print("Getting datas");
    final responseData = await http.get(Uri.parse(Constants.host +
        "/api/chat/" +
        idUser.toString() +
        "/" +
        idContact.toString() +
        "?token=" +
        Constants.token));
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      print(data);
      setState(() {
        for (var i in data) {
          List<String> dates = i['created_at'].toString().split("T");
          DateTime dateTime = dateformat.parse(dates[0] + " " + dates[1]);
          DateTime now = DateTime.now();
          String value = "";
          if (dateTime.year == now.year &&
              dateTime.month == now.month &&
              dateTime.day == now.day) {
            value = Constants.formatNumber(dateTime.hour.toInt()) +
                ":" +
                Constants.formatNumber(dateTime.minute.toInt());
          } else {
            value = Constants.formatNumber(dateTime.day.toInt()) +
                "-" +
                Constants.formatNumber(dateTime.month.toInt()) +
                "-" +
                Constants.formatNumber(dateTime.year.toInt()) +
                " " +
                Constants.formatNumber(dateTime.hour.toInt()) +
                ":" +
                Constants.formatNumber(dateTime.minute.toInt());
          }
          listMessages.add(ModelChatMessage(i['id'], i['message'], value,
              (i['expediteur_id'] == idUser) ? 1 : 2));
        }
        loading = false;
        controllerListView.jumpTo(controllerListView.position.maxScrollExtent);
      });
    }
    setState(() {
      loading = false;
    });
    // actualize();
  }

  _refreshPage(messages) async {
    // listMessages.clear();
    print("Getting datas");
    if (messages.length > 0) {
      setState(() {
        for (var i in messages) {
          List<String> dates = i['created_at'].toString().split("T");
          DateTime dateTime = dateformat.parse(dates[0] + " " + dates[1]);
          DateTime now = DateTime.now();
          String value = "";
          if (dateTime.year == now.year &&
              dateTime.month == now.month &&
              dateTime.day == now.day) {
            value = Constants.formatNumber(dateTime.hour.toInt()) +
                ":" +
                Constants.formatNumber(dateTime.minute.toInt());
          } else {
            value = Constants.formatNumber(dateTime.day.toInt()) +
                "-" +
                Constants.formatNumber(dateTime.month.toInt()) +
                "-" +
                Constants.formatNumber(dateTime.year.toInt()) +
                " " +
                Constants.formatNumber(dateTime.hour.toInt()) +
                ":" +
                Constants.formatNumber(dateTime.minute.toInt());
          }
          try {
            if ((listMessages.singleWhere((it) => it.id == i['id'])) != null) {
              // Found
            } else {
              listMessages.add(ModelChatMessage(i['id'], i['message'], value,
                  (i['expediteur_id'] == idUser) ? 1 : 2));
            }
          } catch (e) {
            listMessages.add(ModelChatMessage(i['id'], i['message'], value,
                (i['expediteur_id'] == idUser) ? 1 : 2));
          }
        }
        loading = false;
      });
    } else {
      final responseData = await http.get(Uri.parse(Constants.host +
          "/api/chat/" +
          idUser.toString() +
          "/" +
          idContact.toString() +
          "?token=" +
          Constants.token));
      if (responseData.statusCode == 200) {
        final data = jsonDecode(responseData.body);
        print(data);
        setState(() {
          for (var i in data) {
            List<String> dates = i['created_at'].toString().split("T");
            DateTime dateTime = dateformat.parse(dates[0] + " " + dates[1]);
            DateTime now = DateTime.now();
            String value = "";
            if (dateTime.year == now.year &&
                dateTime.month == now.month &&
                dateTime.day == now.day) {
              value = Constants.formatNumber(dateTime.hour.toInt()) +
                  ":" +
                  Constants.formatNumber(dateTime.minute.toInt());
            } else {
              value = Constants.formatNumber(dateTime.day.toInt()) +
                  "-" +
                  Constants.formatNumber(dateTime.month.toInt()) +
                  "-" +
                  Constants.formatNumber(dateTime.year.toInt()) +
                  " " +
                  Constants.formatNumber(dateTime.hour.toInt()) +
                  ":" +
                  Constants.formatNumber(dateTime.minute.toInt());
            }
            try {
              if ((listMessages.singleWhere((it) => it.id == i['id'])) !=
                  null) {
                // Found
              } else {
                listMessages.add(ModelChatMessage(i['id'], i['message'], value,
                    (int.parse(i['expediteur_id']) == idUser) ? 1 : 2));
              }
            } catch (e) {
              listMessages.add(ModelChatMessage(i['id'], i['message'], value,
                  (int.parse(i['expediteur_id']) == idUser) ? 1 : 2));
            }
          }
          loading = false;
        });
      }
      setState(() {
        loading = false;
      });
    }
    controllerListView.jumpTo(controllerListView.position.maxScrollExtent);
  }

  Future<void> sendMessage(String message, BuildContext context) async {
    controllerListView.jumpTo(controllerListView.position.maxScrollExtent);
    setState(() {
      isLoading = true;
    });
    Future<String> telephone = SharedPreferencesHelper.getValue("telephone");
    telephone.then((String value) async {
      print(value);
      final response = await http.post(
          Uri.parse(Constants.host +
              "/api/chat/send/" +
              idUser.toString() +
              "/" +
              idContact.toString() +
              "?token=" +
              Constants.token),
          body: {'telephone': value, 'message': message});
      print(response.body);
      setState(() {
        isLoading = false;
      });
      var dataMessages = json.decode(response.body);
      if (dataMessages['error'] == true) {
        _showAlertDialog(
            'Désolé', 'Erreur survenue lors de l\'envoi! Veuillez réessayer');
      } else {
        _refreshPage(dataMessages['messages']);
        controllerListView.jumpTo(controllerListView.position.maxScrollExtent);
      }
    });
  }

  @override
  void initState() {
    getDatas();
    timerRequest = Timer.periodic(Duration(seconds: 10), (_) async {
      _refreshPage([]);
    });
    // controllerListView.jumpTo(controllerListView.position.maxScrollExtent);
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
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              flexibleSpace: SafeArea(
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(Constants.host + avatar),
                        maxRadius: 20,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              pseudo,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Récemment en ligne",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      // Icon(Icons.settings,color: Colors.black54,),
                    ],
                  ),
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                Container(
                    child: Column(
                  children: [
                    Container(
                      child: ListView.builder(
                        itemCount: listMessages.length,
                        shrinkWrap: true,
                        controller: controllerListView,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        itemBuilder: (context, index) {
                          final messageItem = listMessages[index];
                          return Container(
                              padding: EdgeInsets.only(
                                  left: 14, right: 14, top: 10, bottom: 10),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: (messageItem.type == 2
                                        ? Alignment.topLeft
                                        : Alignment.topRight),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: (messageItem.type == 2
                                            ? Colors.grey.shade200
                                            : Colors.blue[200]),
                                      ),
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        messageItem.message,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  Align(
                                      alignment: (messageItem.type == 2
                                          ? Alignment.topLeft
                                          : Alignment.topRight),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 10, left: 10, top: 5),
                                          child: Wrap(
                                            children: [
                                              Text(
                                                messageItem.dateSend,
                                                style: TextStyle(fontSize: 10),
                                                textAlign: TextAlign.left,
                                              ),
                                              /* FaIcon(
                                                FontAwesomeIcons.check,
                                                size: 10,
                                                color: Colors.grey,
                                              ),
                                               FaIcon(
                                                FontAwesomeIcons.check,
                                                size: 10,
                                                color: Colors.grey,
                                              ),*/
                                              (messageItem.type == 1)
                                                  ? FaIcon(
                                                      FontAwesomeIcons
                                                          .checkDouble,
                                                      size: 9,
                                                      color: Colors.grey,
                                                    )
                                                  : SizedBox(),
                                            ],
                                          )))
                                ],
                              ));
                        },
                      ),
                      height: screenSize.height * 0.8,
                    )
                  ],
                )),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    height: 65,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        /* GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  SizedBox(width: 15,),*/
                        Expanded(
                          child: TextField(
                              decoration: InputDecoration(
                                  hintText: "Ecrire un message...",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none),
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              controller: _messageController),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: FloatingActionButton(
                            onPressed: () {
                              final message = _messageController.text.trim();

                              if (message == "") {
                                final snackBar = SnackBar(
                                    content: Text("Contenu vide!"),
                                    action: SnackBarAction(
                                      label: 'Fermer',
                                      onPressed: () {},
                                    ));

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                sendMessage(message, context);
                                _messageController.clear();
                              }
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                            backgroundColor: Colors.blue,
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
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
