import 'package:flutter/material.dart';

const TextStyle kLabelTextStyle = TextStyle(
    color: Colors.lightBlueAccent, fontSize: 30, fontWeight: FontWeight.bold);

const TextStyle kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 30,
);

class RoundedTextField extends StatelessWidget {
  RoundedTextField(
      {this.hintText,
      this.preFixIcon,
      @required this.passwordField,
      this.onchange});

  final String hintText;
  final Widget preFixIcon;
  final bool passwordField;
  final Function onchange;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: passwordField,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        // icon: Icon(Icons.email),
        prefixIcon: preFixIcon,
        border: OutlineInputBorder(
            //borderSide: BorderSide(style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
      onChanged: onchange,
    );
  }
}

class RoundedButton extends StatelessWidget {
  RoundedButton({@required this.onPressed, this.colour, this.text});

  final Function onPressed;
  final Color colour;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: StadiumBorder(),
      minWidth: 350.0,
      height: 42.0,
      onPressed: onPressed,
      color: colour,
      child: Text(
        text,
        style: kButtonTextStyle,
      ),
    );
  }
}
