import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../UI/sign_button.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static String route_name = '/registration';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
              child: Icon(
                Icons.flash_on,
                color: Colors.orange,
                size: 160.0,
              ),
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
              bgColor: Color(0xFF447DF9),
              textButton: 'Register',
              onPress: () async {
                setState((){
                  isLoading = true;
                });
                // Create a User with entred Data
                if (email == null || password == null) {
                  return;
                }
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  // IF User has been created succesfully => the user will be stored in static variable called currentUser
                  if (newUser != null) {
                    Navigator.pushNamed(context, ChatScreen.route_name);
                  }
                  setState((){
                    isLoading = false;
                  });
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
