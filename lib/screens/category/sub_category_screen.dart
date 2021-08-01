import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/services/firebase_services.dart';

class SubCategoryScreen extends StatefulWidget {
  static const String id = 'sub-categoy-list-screen';

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot args = ModalRoute.of(context).settings.arguments;
    print('Id ' + args.id);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(args['catName'], style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          shape: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: _services.categories.doc(args.id).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              );
            }
            List data = snapshot.data['subCat'];
            return Padding(
              padding: const EdgeInsets.only(left: 10,right:10), 
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: data.length == 0
                    ? Center(
                        child: Text("NO!! Sub Categories for This item"),
                      )
                    : ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (_, i) {
                          return ListTile(
                            onTap: () {},
                            title: Text(
                              data[i],
                              style: TextStyle(fontSize: 15),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                            ),
                          );
                        }),
              ),
            );
          },
        ));
  }
}
