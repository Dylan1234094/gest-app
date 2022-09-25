import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

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

class _ChatState extends State<Chat> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  var chatDocId;
  var _textController = new TextEditingController();
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
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUserId,
      'msg': msg
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
    setState(() {});
  }

  bool isSender(String anotherUser) {
    return anotherUser == currentUserId;
  }

  Alignment getAlignment(anotherUser) {
    if (anotherUser == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chats
          .doc(chatDocId)
          .collection('messages')
          .orderBy('createdOn', descending: true)
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

        var data;
        return Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: true,
              title: Text(
                  "${widget.anotherUserName} ${widget.anotherUserSurname}")),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      data = document.data()!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChatBubble(
                          clipper: ChatBubbleClipper6(
                            nipSize: 10,
                            radius: 10,
                            type: isSender(data['uid'].toString())
                                ? BubbleType.sendBubble
                                : BubbleType.receiverBubble,
                          ),
                          margin: const EdgeInsets.only(top: 10),
                          alignment: getAlignment(data['uid'].toString()),
                          backGroundColor: isSender(data['uid'].toString())
                              ? Colors.blue
                              : Color(0xffE7E7ED),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(data['msg'],
                                        style: TextStyle(
                                            color:
                                                isSender(data['uid'].toString())
                                                    ? Colors.white
                                                    : Colors.black,
                                            fontSize: 16),
                                        maxLines: 100,
                                        overflow: TextOverflow.ellipsis)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              buildInput(),
            ],
          ),
        );
      },
    );
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
