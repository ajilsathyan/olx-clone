

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:olx_clone/services/firebase_services.dart';


class CategoryProvider with ChangeNotifier {
  FirebaseServices _services= FirebaseServices();
  DocumentSnapshot doc;
  DocumentSnapshot userDetails;
  String selectedItem;
  String selectedSub;
  List<String> listUrls=[];
  Map<String,dynamic> sellerCarFormData={};

  getCategory(selected) {
    this.selectedItem = selected;
    notifyListeners();
  }

  getSubCategory(selectedSub){
    this.selectedSub=selectedSub;
    notifyListeners();
  }
  getSnapShot(snapShot){
    this.doc=snapShot;
    notifyListeners();
  }

  getDownloadedImageUrls(urls){
    this.listUrls.add(urls);
    notifyListeners();
  }

  getSellerCarFormDataToFireStore(data){
    this.sellerCarFormData=data;
    notifyListeners();
  }

  clearDataFields(){
    listUrls=[];
    sellerCarFormData={};
    notifyListeners();
  }

}
