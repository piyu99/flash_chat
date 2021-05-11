import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class ChatScreen extends StatefulWidget {

  static const String id='chatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  FirebaseAuth _auth=FirebaseAuth.instance;
  User user;
  String message;
  final messageController=TextEditingController();
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    print(user.email);
  }

  getCurrentUser(){
    User _user=_auth.currentUser;
    if(_user!=null){
      user=_user;
    }
  }

  logout(){
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                logout();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('messages').snapshots(),
                builder: (context, snapshot){
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder : (context,index) {
                      bool isMe;
                      if(snapshot.data.docs[index].get('sender')==user.email){
                        return ListTile(
                          title: Text(snapshot.data.docs[index].get('text'),
                            textAlign: TextAlign.right,
                            style: TextStyle(

                            ),),
                          subtitle: Text(snapshot.data.docs[index].get('sender'),
                            textAlign: TextAlign.right,
                          ),
                        );
                      }
                      else{
                        return ListTile(

                          title: Text(snapshot.data.docs[index].get('text'),
                            textAlign: TextAlign.left,
                            style: TextStyle(

                            ),),
                          subtitle: Text(snapshot.data.docs[index].get('sender'),
                            textAlign: TextAlign.left,
                          ),
                        );
                      }

                    }
                  );
                },
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        message=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageController.clear();
                      FirebaseFirestore.instance.collection('messages').add(
                        {
                        'text': message,
                        'sender':'piyu'
                        }
                      );
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
