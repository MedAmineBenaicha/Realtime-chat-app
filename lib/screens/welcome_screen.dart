import 'package:flutter/material.dart';

import '../UI/sign_button.dart';
import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static String route_name = '/welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new AnimationController(
        duration: Duration(seconds: 1),
        vsync:
            this); // create an instance of controller and select duration and Thicker
    animation = new CurvedAnimation(
        parent: controller,
        curve:
            Curves.decelerate); // we create the animation => curved Animation
    controller.forward(); // start running the animation forward ( from 0 to 1 )
    controller.addListener(() {
      setState(() {});
      print(animation
          .value); // because the add Listner method will be called on each time the controller value had been changed
      // That's why we need to call the setState method to explicit the re-build of our widget => Animation shows corectlly
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Destruct animation controller after Quitting the screen
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/icon_chat.png'),
                  radius: animation.value * 80.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 50.0),
          SignButton(
            bgColor: Colors.lightBlueAccent,
            textButton: 'Login',
            onPress: () {
              Navigator.pushNamed(context, LoginScreen.route_name);
            },
          ),
          SignButton(
            bgColor: Color(0xFF447DF9),
            textButton: 'Register',
            onPress: () {
              Navigator.pushNamed(context, RegistrationScreen.route_name);
            },
          )
        ],
      ),
    );
  }
}
