import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/provider/category_provider.dart';
import 'package:olx_clone/screens/Authentication/email_auth_screen.dart';
import 'package:olx_clone/screens/Authentication/email_password_reset_screen.dart';
import 'package:olx_clone/screens/Authentication/email_verification_screen.dart';
import 'package:olx_clone/screens/Authentication/phone_auth_screen.dart';
import 'package:olx_clone/screens/category/category_list_screen.dart';
import 'package:olx_clone/screens/category/sub_category_screen.dart';
import 'package:olx_clone/screens/forms/seller_car_form.dart';
import 'package:olx_clone/screens/forms/seller_review_screen.dart';
import 'package:olx_clone/screens/location_screen.dart';
import 'package:olx_clone/screens/login_screen.dart';
import 'package:olx_clone/screens/Authentication/otp_screen.dart';
import 'package:olx_clone/screens/main_screen.dart';
import 'package:olx_clone/screens/sellerItems/Seller_category_List_Screen.dart';
import 'package:olx_clone/screens/sellerItems/Seller_sub_category_screen.dart';
import 'package:olx_clone/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.cyan.shade900,
        fontFamily: "Lato",
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan.shade900),
              borderRadius: BorderRadius.circular(4)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: Colors.cyan.shade900, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.cyan.shade900),
          contentPadding: EdgeInsets.only(left: 10),
        ),
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        PhoneAuthentication.id: (context) => PhoneAuthentication(),
        OTPScreen.id: (context) => OTPScreen(),
        LocationScreen.id: (context) => LocationScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        EmailAuthScreen.id: (context) => EmailAuthScreen(),
        EmailPasswordResetScreen.id: (context) => EmailPasswordResetScreen(),
        EmailVerificationScreen.id: (context) => EmailVerificationScreen(),
        CategoryListScreen.id: (context) => CategoryListScreen(),
        SubCategoryScreen.id: (context) => SubCategoryScreen(),
        MainScreen.id: (context) => MainScreen(),
        SellerCategoryListsScreen.id: (context) => SellerCategoryListsScreen(),
        SellerSubCategoryScreen.id: (context) => SellerSubCategoryScreen(),
        SellerCarFormScreen.id: (context) => SellerCarFormScreen(),
        SellerReviewScreen.id:(context)=>SellerReviewScreen(),
      },
    );
  }
}
