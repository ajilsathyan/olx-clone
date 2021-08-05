import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/login_screen.dart';
class AccountScreen extends StatefulWidget {


  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  StreamSubscription<User> _subscription;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            FirebaseAuth.instance.signOut().then((value){
              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
            });
          },
          icon: Icon(Icons.logout),
        ),
      ),
      body: Center(
        child: Text(
            'Account Screen'
        ),
      ),
    );
  }

  @override
  void dispose() {

    _subscription.cancel();
    super.dispose();
  }
}
