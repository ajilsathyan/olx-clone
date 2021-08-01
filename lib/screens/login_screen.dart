import 'package:flutter/material.dart';
import 'package:olx_clone/widgets/authUi.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Image.asset(
                        "assets/images/cartIcon.png",
                        color: Colors.cyan.shade900,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Buy or Sell",
                      style: TextStyle(
                          color: Colors.cyan.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: "Lato"),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: AuthUI(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "If you contiue, you are accepting\n Terms and Conditions and Privacy policy",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
