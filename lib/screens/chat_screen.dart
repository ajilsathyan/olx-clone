
import 'package:flutter/material.dart';
class ChatScreen extends StatefulWidget {
  static const String id='chat-screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Chat Screen'
        ),
      ),
    );
  }
}
