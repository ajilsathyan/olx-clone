import 'package:flutter/material.dart';
import 'package:olx_clone/screens/location_screen.dart';
import 'package:open_mail_app/open_mail_app.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const String id = 'email-verification-screen';

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Verify Your Email ",
                style: TextStyle(
                    fontSize: 26,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text("Check your email to verify your registered email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(10.0),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor)),
                        onPressed: () async {
                          var result = await OpenMailApp.openMailApp();

                          // If no mail apps found, show error
                          if (!result.didOpen && !result.canOpen) {
                            showNoMailAppsDialog(context);

                            // iOS: if multiple mail apps found, show dialog to select.
                            // There is no native intent/default app system in iOS so
                            // you have to do it yourself.
                          } else if (!result.didOpen && result.canOpen) {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return MailAppPickerDialog(
                                  mailApps: result.options,
                                );
                              },
                            );
                          }
                          Navigator.pushReplacementNamed(
                              context, LocationScreen.id);
                        },
                        child: Text("Open Email")),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
