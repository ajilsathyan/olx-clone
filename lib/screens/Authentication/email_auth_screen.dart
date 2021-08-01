import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/Authentication/email_password_reset_screen.dart';
import 'package:olx_clone/services/email_auth_services.dart';



class EmailAuthScreen extends StatefulWidget {
  static const String id = 'email-auth-screen';

  @override
  _EmailAuthScreenState createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  bool validate = false;
  bool _login = false;
  bool loading = false;
  bool isPasswordSee = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  EmailAuthServices _services = EmailAuthServices();
  validateEmailAndPassword() {
    if (formKey.currentState.validate()) {
      setState(() {
        validate = false;
        loading = true;
      });

      /// User Login or Register
      _services
          .getAdminCredentials(
              context: context,
              password: passwordController.text,
              email: emailController.text,
              isLog: _login)
          .then((value) {
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          _login ? "Login" : "Register",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.red.shade200,
                  child: Icon(
                    CupertinoIcons.person_alt_circle,
                    color: Colors.redAccent,
                    size: 50,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  _login ? 'Login' : 'Register',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Enter Email and Password to ${_login ? 'login' : 'Register'}",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    final bool isValid =
                        EmailValidator.validate(emailController.text);
                    if (value == null || value.isEmpty) {
                      return 'Enter email';
                    }
                    if (value.isNotEmpty && isValid == false) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  textAlignVertical: TextAlignVertical.center,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),

                      suffixIcon: Icon(Icons.email_outlined),
                      labelText: "email",
                      hintText: "xyz1999@gmail.com",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (value) {
                    if (emailController.text.isNotEmpty) {
                      if (value.length > 5) {
                        setState(() {
                          validate = true;
                        });
                      } else {
                        setState(() {
                          validate = false;
                        });
                      }
                    }
                  },
                  textAlignVertical: TextAlignVertical.center,
                  autofocus: true,
                  obscureText: isPasswordSee,
                  controller: passwordController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordSee = !isPasswordSee;
                            });
                          },
                          icon: Icon(isPasswordSee
                              ? CupertinoIcons.eye_slash
                              : Icons.remove_red_eye)),
                      contentPadding: EdgeInsets.only(left: 10),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(4)),
                      labelText: "password",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, EmailVerificationScreen.id);
                    Navigator.pushNamed(context, EmailPasswordResetScreen.id);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text("forgot password?",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ),
                ),
                Row(
                  children: [
                    Text(_login ? 'New user ?' : 'Already has an account?'),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _login = !_login;
                          });
                        },
                        child: Text(
                          _login ? 'Register' : 'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: AbsorbPointer(
            absorbing: validate ? false : true,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: validate
                      ? MaterialStateProperty.all(
                          Theme.of(context).primaryColor)
                      : MaterialStateProperty.all(Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      )
                    : Text(_login ? 'Login' : 'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
              ),
              onPressed: () {
                validateEmailAndPassword();
              },
            ),
          ),
        ),
      ),
    );
  }
}
