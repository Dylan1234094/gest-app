import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  final String nombreSender;
  final String apellidoSender;
  final String anotherUserUid;
  final String anotherUserName;
  final String anotherUserSurname;
  final String anotherUserFCMToken;

  Chat(
      {Key? key,
      required this.nombreSender,
      required this.apellidoSender,
      required this.anotherUserUid,
      required this.anotherUserName,
      required this.anotherUserSurname,
      required this.anotherUserFCMToken})
      : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class MessageChat {
  String idFrom;
  String idTo;
  String timestamp;
  String content;

  MessageChat(
      {required this.idFrom,
      required this.idTo,
      required this.timestamp,
      required this.content});

  Map<String, dynamic> toJson() {
    return {
      "idFrom": this.idFrom,
      "idTo": this.idTo,
      "timestamp": this.timestamp,
      "content": this.content,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get("idFrom");
    String idTo = doc.get("idTo");
    String timestamp = doc.get("timestamp");
    String content = doc.get("content");
    return MessageChat(
        idFrom: idFrom, idTo: idTo, timestamp: timestamp, content: content);
  }
}

class _ChatState extends State<Chat> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  var chatDocId;
  var _textController = new TextEditingController();
  final ScrollController listScrollController = ScrollController();

  bool isLoading = false;

  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await chats
        .where('users',
            isEqualTo: {widget.anotherUserUid: null, currentUserId: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                chatDocId = querySnapshot.docs.single.id;
              });

              print(chatDocId);
            } else {
              await chats.add({
                'users': {currentUserId: null, widget.anotherUserUid: null}
              }).then((value) => {chatDocId = value});
            }
          },
        )
        .catchError((error) {});
  }

  void sendMessage(String msg) {
    if (msg == '') return;
    chats.doc(chatDocId).collection('messages').add({
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'idFrom': currentUserId,
      'idTo': widget.anotherUserUid,
      'content': msg
    }).then((value) async {
      _textController.text = '';
      var url =
          'https://upc-cloud-test.azurewebsites.net/api/sendChatNotification';
      Map data = {
        'nombreSender': widget.nombreSender,
        'apellidoSender': widget.apellidoSender,
        'idSender': currentUserId,
        'fcmReceiverToken': widget.anotherUserFCMToken
      };
      var body = json.encode(data);
      try {
        var response = await http.post(Uri.parse(url),
            headers: {"Content-Type": "application/json"}, body: body);
        print(response.body);
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title:
              Text("${widget.anotherUserName} ${widget.anotherUserSurname}")),
      body: Column(
        children: <Widget>[
          // List of messages
          buildListMessages(context),
          // Input content
          buildInput(),
        ],
      ),
    );
  }

  Widget buildListMessages(BuildContext context) {
    var data;
    return StreamBuilder<QuerySnapshot>(
        stream: chats
            .doc(chatDocId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Algo salió mal"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("Todavia no se han enviado mensajes"),
            );
          }
          return Expanded(
              child: ListView(
            reverse: true,
            children:
                snapshot.data!.docs.map<Widget>((DocumentSnapshot document) {
              return buildItem(document);
            }).toList(),
          ));
        });
  }

  Widget buildItem(DocumentSnapshot? document) {
    if (document == null) {
      return const SizedBox.shrink();
    }
    MessageChat messageChat = MessageChat.fromDocument(document);
    if (messageChat.idFrom == currentUserId) {
      // Right (my message)
      return Row(
        children: <Widget>[
          Column(
            children: [
              Container(
                child: Text(
                  messageChat.content,
                  style: TextStyle(color: Colors.white),
                ),
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.only(right: 10),
              ),
              Container(
                child: Text(
                  DateFormat('dd MMM kk:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(messageChat.timestamp))),
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 8,
                      fontStyle: FontStyle.italic),
                ),
                margin: EdgeInsets.only(left: 140, top: 5, bottom: 5),
              ),
            ],
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                messageChat.content,
                style: TextStyle(color: Colors.blue),
              ),
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              width: 200,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.only(left: 10),
            ),
            Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(messageChat.timestamp))),
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 8,
                    fontStyle: FontStyle.italic),
              ),
              margin: const EdgeInsets.only(left: 165, top: 5, bottom: 5),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: const EdgeInsets.only(bottom: 10),
      );
    }
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(left: 15),
              child: TextField(
                onSubmitted: (value) {
                  sendMessage(_textController.text);
                },
                style: const TextStyle(color: Colors.black, fontSize: 15),
                controller: _textController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Escribe tu mensaje...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
                autofocus: true,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => sendMessage(_textController.text),
                color: Colors.blue,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }
}
