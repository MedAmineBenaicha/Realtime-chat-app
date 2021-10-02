import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'login_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static String route_name = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User loggedUser;
  late String text;
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void getUserData() async {
    try {
      final user = await _auth.currentUser;

      if (user != null) {
        loggedUser = user;
        print(loggedUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void getMessages() async {
    final messages =
        await _firestore.collection('messages').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
      });
    });
  }

  void messagesStream() async {
    print('we are printing messages');
    await for (var snapshots in _firestore.collection('messages').snapshots()) {
      snapshots.docs.forEach((result) {
        print(result.data());
      });
    }
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
                //Implement logout functionality
                _auth.signOut();
                // Push user to login Screen after signing out
                Navigator.pushNamed(context, LoginScreen.route_name);
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
            StreamBuilder(
              stream: _firestore
                  .collection("messages")
                  .withConverter<Map<String, dynamic>>(
                    fromFirestore: (snapshot, _) =>
                        snapshot.data() ?? Map<String, dynamic>(),
                    toFirestore: (model, _) =>
                        Map<String, dynamic>.from(model as Map),
                  )
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ));
                }
                final messages = snapshot.data?.docs.reversed;
                List<MessageBubble> MessageBubbles = [];
                for (var message in messages!) {
                  final messageText = message.data()['text'];
                  final messageSender = message.data()['sender'];
                  final messageWidget = MessageBubble(
                      text: messageText,
                      sender: messageSender,
                      loggedUserEmail: loggedUser.email);

                  MessageBubbles.add(messageWidget);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    children: MessageBubbles,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                        text = value;
                      },
                      controller: editingController,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality. => Store message to FireStore
                      if (text == null) {
                        return;
                      }
                      _firestore.collection('messages').add(
                        {'text': text, 'sender': loggedUser.email},
                      );
                      editingController.clear();
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

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final String? loggedUserEmail;
  const MessageBubble(
      {required this.text,
      required this.sender,
      required this.loggedUserEmail});

  @override
  Widget build(BuildContext context) {
    bool isLoggedUser = (loggedUserEmail == sender);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment:
              isLoggedUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Material(
              color: isLoggedUser ? Colors.lightBlueAccent : Color(0xFFDEDEE1),
              borderRadius: isLoggedUser
                  ? BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(0.0),
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0))
                  : BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: isLoggedUser ? Colors.white : Colors.black),
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              'from $sender',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: Colors.grey,
              ),
            )
          ]),
    );
  }
}
