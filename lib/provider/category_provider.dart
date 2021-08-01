

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class CategoryProvider with ChangeNotifier {
  DocumentSnapshot doc;
  String selectedItem;

  List<String> listUrls=[];
  Map<String,dynamic> sellerCarFormData={};

  getCategory(selected) {
    this.selectedItem = selected;
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

}
