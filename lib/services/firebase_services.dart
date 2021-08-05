import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:olx_clone/provider/category_provider.dart';

class FirebaseServices {
  User user = FirebaseAuth.instance.currentUser;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  Future<void> updateUserData(Map<String, dynamic> data, context) {
    return users.doc(user.uid).update(data).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User Details Updated successfully"),
        ),
      );
    }).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to update"),
          ),
        ));
  }

  Future<String> getUserAddress(lat, lon) async {
    final coordinates = new Coordinates(lat.latitude, lon.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    return first.addressLine;
  }

  ///
  Future<DocumentSnapshot> getUserData() async {
    DocumentSnapshot doc = await users.doc(user.uid).get();
    return doc;
  }

  Future<void> updateUserDataForSellingItems(
      {Map<String, dynamic> data, context, catprovider,userName}) {
    return users.doc(user.uid).update({'contact_details': data,'username':userName}).then((value) {
      saveSellerProductToDataBase(
          context: context, sellerCarFormData: catprovider.sellerCarFormData,catProvider: catprovider);
    }).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to update"),
          ),
        ));
  }

  Future<void> saveSellerProductToDataBase({context, sellerCarFormData,CategoryProvider catProvider}) {
    return products.add(sellerCarFormData).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("items have been added to DataBase"),
        ),
      );

    }).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed!!")),
        ));
  }
}
