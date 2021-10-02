import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/chat_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: WelcomeScreen.route_name,
      routes: {
        WelcomeScreen.route_name: (context) => WelcomeScreen(),
        LoginScreen.route_name: (context) => LoginScreen(),
        RegistrationScreen.route_name: (context) => RegistrationScreen(),
        ChatScreen.route_name: (context) => ChatScreen(),
      },
    );
  }
}
