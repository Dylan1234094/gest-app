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
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await chats
        .where('users', isEqualTo: {widget.anotherUserUid: null, currentUserId: null})
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
    chats
        .doc(chatDocId)
        .collection('messages')
        .add({'createdOn': FieldValue.serverTimestamp(), 'uid': currentUserId, 'msg': msg}).then((value) async {
      _textController.text = '';
      var url = 'https://upc-cloud-test.azurewebsites.net/api/sendChatNotification';
      Map data = {
        'nombreSender': widget.nombreSender,
        'apellidoSender': widget.apellidoSender,
        'idSender': currentUserId,
        'fcmReceiverToken': widget.anotherUserFCMToken
      };
      var body = json.encode(data);
      try {
        var response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
        print(response.body);
      } catch (e) {
        print(e);
      }
    });
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
      stream: chats.doc(chatDocId).collection('messages').orderBy('createdOn', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          var data;
          return Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text("${widget.anotherUserName} ${widget.anotherUserSurname}")),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    reverse: true,
                    children: snapshot.data!.docs.map(
                      (DocumentSnapshot document) {
                        data = document.data()!;
                        print(document.toString());
                        print(data['msg']);

                        //Timestamp CreatedOn;

                        //if (data['createdOn'] == null) {
                        //  CreatedOn = DateTime.now() as Timestamp;
                        //} else {
                        //  CreatedOn = data['createdOn'] as Timestamp;
                        //}
                        //DateTime dateCreatedOn = CreatedOn.toDate();

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChatBubble(
                            clipper: ChatBubbleClipper6(
                              nipSize: 10,
                              radius: 10,
                              type:
                                  isSender(data['uid'].toString()) ? BubbleType.sendBubble : BubbleType.receiverBubble,
                            ),
                            margin: const EdgeInsets.only(top: 10),
                            alignment: getAlignment(data['uid'].toString()),
                            backGroundColor: isSender(data['uid'].toString()) ? Colors.blue : Color(0xffE7E7ED),
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
                                              color: isSender(data['uid'].toString()) ? Colors.white : Colors.black,
                                              fontSize: 16),
                                          maxLines: 100,
                                          overflow: TextOverflow.ellipsis)
                                    ],
                                  ),
                                  /*
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(r
                                        data['createdOn'] == null
                                            ? DateTime.now().toString()
                                            : '${dateCreatedOn.day}/${dateCreatedOn.month} ${dateCreatedOn.hour}:${dateCreatedOn.minute}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                isSender(data['uid'].toString())
                                                    ? Colors.white
                                                    : Colors.black),
                                      )
                                    ],
                                  )*/
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () => sendMessage(_textController.text),
                        icon: const Icon(
                          Icons.send,
                          color: Colors.blue,
                        ))
                  ],
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
