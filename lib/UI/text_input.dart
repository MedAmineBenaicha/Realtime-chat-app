import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final Icon icon;
  final Color bgColor;
  final Color borderColor;
  final String textHint;
  final double marginTop;
  final bool isPassword;

  const TextInput(
      {required this.icon,
      required this.borderColor,
      required this.textHint,
      required this.bgColor,
      required this.marginTop,
      required this.isPassword});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
      margin: EdgeInsets.fromLTRB(30.0, marginTop, 40.0, 10.0),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(width: 2.0, color: borderColor),
        borderRadius: BorderRadius.circular(40.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.3),
        //     spreadRadius: 1,
        //     blurRadius: 3,
        //     offset: Offset(0, 3), // changes position of shadow
        //   ),
        // ],
      ),
      child: TextFormField(
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: icon,
          border: InputBorder.none,
          hintText: textHint,
        ),
      ),
    );
  }
}
