import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utilities/designs.dart';

class Chat extends StatefulWidget {
  final String nombreSender;
  final String apellidoSender;
  final String anotherUserUid;
  final String anotherUserName;
  final String anotherUserSurname;
  final String anotherUserFCMToken;

  const Chat(
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
      "idFrom": idFrom,
      "idTo": idTo,
      "timestamp": timestamp,
      "content": content,
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
  final _textController = TextEditingController();
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

              //print(chatDocId);
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
      // var url =
      //     'https://upc-cloud-test.azurewebsites.net/api/sendChatNotification';
      // Map data = {
      //   'nombreSender': widget.nombreSender,
      //   'apellidoSender': widget.apellidoSender,
      //   'idSender': currentUserId,
      //   'fcmReceiverToken': widget.anotherUserFCMToken
      // };
      //var body = json.encode(data);
      try {
        // var response = await http.post(Uri.parse(url),
        //     headers: {"Content-Type": "application/json"}, body: body);
        //print(response.body);
      } catch (e) {
        //print(e);
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
        title: Text(
          "${widget.anotherUserName} ${widget.anotherUserSurname}",
          style: kTituloCabezera.copyWith(fontSize: 11.0),
        ),
      ),
      body: Column(
        children: [
          // List of messages
          StreamBuilder<QuerySnapshot>(
            stream: chats
                .doc(chatDocId)
                .collection('messages')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  children: snapshot.data!.docs
                      .map<Widget>((DocumentSnapshot document) {
                    return buildItem(document);
                  }).toList(),
                ),
              );
            },
          ),
          // Input content
          Container(
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
                        hintText: 'Escribe un mensaje...',
                        hintStyle: kSubTitulo1,
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
                      color: colorPrincipal,
                    ),
                  ),
                ),
              ],
            ),
            width: double.infinity,
            height: 50,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(DocumentSnapshot? document) {
    if (document == null) {
      return const SizedBox.shrink();
    }
    MessageChat messageChat = MessageChat.fromDocument(document);
    return BurbujaMensaje(
      messageChat: messageChat,
      isMe: messageChat.idFrom == currentUserId,
    );
  }
}

class BurbujaMensaje extends StatelessWidget {
  const BurbujaMensaje({
    Key? key,
    required this.messageChat,
    required this.isMe,
  }) : super(key: key);

  final MessageChat messageChat;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Card(
          color: isMe ? colorPrincipal : colorSecundario,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  messageChat.content,
                  style: const TextStyle(color: Colors.white, fontSize: 10.0),
                  textAlign: TextAlign.start,
                ),
                Text(
                  DateFormat('d/M kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(messageChat.timestamp),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8.0,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
