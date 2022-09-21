// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gest_app/chats/pages/chat_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../chats/constants/constants.dart';
import '../../chats/models/models.dart';
import '../../chats/providers/providers.dart';
import '../../chats/utils/utils.dart';
import '../../chats/widgets/widgets.dart';

class GestListChat extends StatefulWidget {
  GestListChat({Key? key}) : super(key: key);

  @override
  State createState() => GestListChatState();
}

class GestListChatState extends State<GestListChat> {
  GestListChatState({Key? key});

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  int _limitIncrement = 20;
  bool isLoading = false;
  String _textSearch = "";

  late AuthProvider authProvider;
  late User currentUser;
  late String currentUserId;
  late HomeProvider homeProvider;
  Debouncer searchDebouncer = Debouncer(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
    homeProvider = context.read<HomeProvider>();

    currentUser = FirebaseAuth.instance.currentUser!;
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    registerNotification();
    configLocalNotification();
    listScrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void registerNotification() {
    firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      (Map<String, dynamic> message) async =>
          print('onBackground Handler $message');
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) => print('onBackground Handler $message'));

    Future _backgroundHandler(RemoteMessage message) async {
      print('onBackground Handler $message');
    }

    Future _onMessageHandler(RemoteMessage message) async {
      print('OnMessage Handler $message');
    }

    Future _onMessageOpenAppHandler(RemoteMessage message) async {
      print('OnMessageOpenApp Handler $message');
    }

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      Platform.isAndroid ? 'com.example.gest_app' : 'com.example.gest_app',
      'Flutter chat demo',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    print(remoteNotification);

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Conversaciones",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: WillPopScope(
          child: Stack(
            children: <Widget>[
              // List
              Column(
                children: [
                  buildSearchBar(),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: homeProvider.getGestantList(currentUserId),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if ((snapshot.data?.docs.length ?? 0) > 0) {
                            return ListView.builder(
                              padding: EdgeInsets.all(10),
                              itemBuilder: (context, index) => buildItem(
                                  context, snapshot.data?.docs[index]),
                              itemCount: snapshot.data?.docs.length,
                              controller: listScrollController,
                            );
                          } else {
                            return Center(
                              child: Text("No users"),
                            );
                          }
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorConstants.themeColor,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),

              // Loading
              Positioned(
                child: isLoading ? LoadingView() : SizedBox.shrink(),
              )
            ],
          ),
          onWillPop: null,
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot? document) {
    if (document != null) {
      UserChat userChat = UserChat.fromDocument(document);
      if (userChat.nickname.toLowerCase().contains(_textSearch.toLowerCase())) {
        if (userChat.id == currentUserId) {
          return SizedBox.shrink();
        } else {
          return Column(
            children: [
              Container(
                child: TextButton(
                  child: Row(
                    children: <Widget>[
                      Material(
                        child: userChat.photoUrl.isNotEmpty
                            ? Image.network(
                                userChat.photoUrl,
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: ColorConstants.themeColor,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, object, stackTrace) {
                                  return Icon(
                                    Icons.account_circle,
                                    size: 50,
                                    color: ColorConstants.greyColor,
                                  );
                                },
                              )
                            : Icon(
                                Icons.account_circle,
                                size: 50,
                                color: ColorConstants.greyColor,
                              ),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      Flexible(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  userChat.nickname,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: ColorConstants.primaryColor,
                                      fontSize: 20),
                                ),
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(left: 20),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (Utilities.isKeyboardShowing()) {
                      Utilities.closeKeyboard(context);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          arguments: ChatPageArguments(
                            peerId: userChat.id,
                            peerAvatar: userChat.photoUrl,
                            peerNickname: userChat.nickname,
                          ),
                        ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 5, left: 5, right: 5),
              ),
            ],
          );
        }
      } else {
        return SizedBox.shrink();
      }
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildSearchBar() {
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: TextField(
                onChanged: (value) {
                  searchDebouncer.run(
                    () {
                      setState(
                        () {
                          _textSearch = value;
                        },
                      );
                    },
                  );
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                  hintText: 'Buscar paciente',
                ),
              ),
            ),
          )
        ],
      ),
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
    );
  }
}
