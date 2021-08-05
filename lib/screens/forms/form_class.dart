import 'package:flutter/material.dart';

class FormClass{
  AppBar app({title,getSnapShot}){
    return AppBar(

      elevation: 0,
      title: Text(title,style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      shape: Border(
        bottom: BorderSide(color: Colors.grey),
      ),
    );
  }
}