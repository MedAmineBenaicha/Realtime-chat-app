import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../UI/sign_button.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String route_name = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/icon_chat.png'),
                  radius: 100.0),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
              margin: EdgeInsets.fromLTRB(30.0, 40.0, 40.0, 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2.0, color: Color(0xCBC7C7B3)),
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: TextFormField(
                onChanged: (value) {
                  email = value;
                },
                obscureText: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_rounded,
                    color: Color(0x85857FCB),
                  ),
                  border: InputBorder.none,
                  hintText: 'email',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
              margin: EdgeInsets.fromLTRB(30.0, 0.0, 40.0, 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2.0, color: Color(0xCBC7C7B3)),
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: TextFormField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_rounded,
                    color: Color(0x85857FCB),
                  ),
                  border: InputBorder.none,
                  hintText: 'password',
                ),
              ),
            ),
            SignButton(
              bgColor: Colors.lightBlueAccent,
              textButton: 'Login',
              onPress: () async {
                setState(() {
                  isLoading = true;
                });
                // Sign user with entred Data
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: this.email, password: this.password);
                  setState(() {
                    isLoading = false;
                  });
                  // Navigate to Chat Screen
                  Navigator.pushNamed(context, ChatScreen.route_name);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
