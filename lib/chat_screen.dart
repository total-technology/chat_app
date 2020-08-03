import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChatScreen extends StatefulWidget {
  static final String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;

/*  void setData() async {
*/ /*    final messages = await _firestore.collection('messages').getDocuments();
    for (var i in messages.documents) {
      print(i.data);
    }*/ /*

    final messages = _firestore.collection('messages').snapshots();
    await for (var i in messages) {
      for (var snapshots in i.documents) {
        print(snapshots.data);
      }
    }

    //.setData({'text': 'hi hola', 'user': 'ullu@bullu.com'});
  }*/

  FirebaseUser loggedInUser;

  void getUserInfo() async {
    var user = await _auth.currentUser();
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });

      print(loggedInUser.email);
    }
  }

  void sendData(String textData) async {
    await _firestore
        .collection('messages')
        .add({'text': textData, 'user': loggedInUser.email});
    print(loggedInUser.email);
  }

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    String text;
    bool showSpinner = false;
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                FlatButton(
                  child: Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    showSpinner = true;
                    if (_auth.currentUser() != null) {
                      await _auth.signOut();
                      Navigator.pop(context);
                      showSpinner = false;
                    }
                  },
                )
              ],
              backgroundColor: Color(0xff00A3FF),
              title: Text('Lets Chat'),
              centerTitle: true,
              elevation: 20,
              automaticallyImplyLeading: true,
              leading: Icon(Icons.chat_bubble_outline),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('messages').snapshots(),
                  builder: (context, snapshot) {
                    List<MessageBubble> messageWidget = [];
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blue,
                        ),
                      );
                    }
                    final message = snapshot.data.documents.reversed;
                    for (var i in message) {
                      var text = i.data['text'];
                      var user = i.data['user'];
                      final messageWidgets =
                          MessageBubble(text, user, user == loggedInUser.email);
                      messageWidget.add(messageWidgets);
                    }
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: ListView(
                          reverse: true,
                          padding: EdgeInsets.all(20),
                          children: messageWidget,
                        ),
                      ),
                    );
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8, left: 8),
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: 'your text here',
                            border: OutlineInputBorder(
                                //borderSide: BorderSide(style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                          ),
                          onChanged: (value) {
                            text = value;
                          },
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        print(text);
                        sendData(text);
                        textController.clear();
                      },
                      child: Icon(
                        Icons.send,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String user;
  final String text;
  final bool isMe;

  MessageBubble(this.text, this.user, this.isMe);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(user),
          Material(
              color: isMe ? Colors.blue : Colors.grey,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))
                  : BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 20),
                ),
              )),
        ],
      ),
    );
  }
}
