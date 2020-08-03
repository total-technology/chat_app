import 'package:baklol/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'constant.dart';

class RegisterScreen extends StatefulWidget {
  static final String id = 'registration_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

bool _saving = false;

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    String username;
    String password;
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Scaffold(
          body: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 40.0,
                  ),
                ),
              ),
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
                    style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
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
                  await _auth.createUserWithEmailAndPassword(
                      email: username, password: password);
                  await _auth.currentUser().whenComplete(
                      () => Navigator.pushNamed(context, LoginScreen.id));
                  setState(() {
                    _saving = false;
                  });
                },
                colour: Color(0xff659D50),
                text: 'register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
