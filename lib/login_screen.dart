import 'package:baklol/chat_screen.dart';
import 'package:baklol/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'constant.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

bool _saving = false;
FirebaseAuth _auth = FirebaseAuth.instance;
String username;
String password;

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _saving,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'try',
                  child: Icon(
                    Icons.chat_bubble,
                    color: Color.fromARGB(255, 219, 185, 75),
                    size: 60,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Lets Chat',
                  style: kLabelTextStyle,
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            RoundedTextField(
              passwordField: false,
              hintText: 'Email Address',
              preFixIcon: Icon(Icons.email),
              onchange: (value) {
                username = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            RoundedTextField(
              passwordField: true,
              hintText: 'Password',
              preFixIcon: Icon(Icons.lock_open),
              onchange: (value) {
                password = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            RoundedButton(
              onPressed: () async {
                setState(() {
                  _saving = true;
                });
                await _auth.signInWithEmailAndPassword(
                    email: username, password: password);

                await _auth.currentUser().catchError((err) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text(err.message),
                          actions: [
                            FlatButton(
                              child: Text("Ok"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                });
                await _auth.currentUser().whenComplete(
                    () => Navigator.pushNamed(context, ChatScreen.id));
                setState(() {
                  _saving = false;
                });
              },
              colour: Color(0xff365899),
              text: 'LOGIN',
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Don\'t have a account?',
              style: kButtonTextStyle.copyWith(
                  color: Colors.black87, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            RoundedButton(
              onPressed: () {
                Navigator.pushNamed(context, RegisterScreen.id);
              },
              colour: Color(0xff659D50),
              text: 'REGISTER NOW',
            ),
          ],
        ),
      ),
    );
  }
}
