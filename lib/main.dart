import 'package:baklol/chat_screen.dart';
import 'package:baklol/login_screen.dart';
import 'package:baklol/register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
      initialRoute: LoginScreen.id,
    );
  }
}
