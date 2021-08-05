import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:olx_clone/constants/constant_input_text_field_decorations.dart';
import 'package:olx_clone/provider/category_provider.dart';
import 'package:olx_clone/screens/forms/seller_review_screen.dart';
import 'package:olx_clone/screens/main_screen.dart';
import 'package:olx_clone/services/firebase_services.dart';
import 'package:olx_clone/widgets/image_picker_widget.dart';
import 'package:provider/provider.dart';

import 'form_class.dart';
class FormsScreen extends StatefulWidget {
 static const String id='forms-screen';

  @override
  _FormsScreenState createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  FormClass formClass=FormClass();
  FirebaseServices services=FirebaseServices();
  var _formKey=GlobalKey<FormState>();
 var _brandText=TextEditingController();
 var _addTitleController=TextEditingController();
 var _descriptionController=TextEditingController();
 var _priceController=TextEditingController();


  List<String> _fuelList = ['Diesel', 'Petrol', 'Electric', 'LPG'];
  List<String> _transmissionList = ['Manually', 'Automatic'];
  List<String> _noOfOwners = ['1', '2', '3', '4', '4+'];


  @override
  Widget build(BuildContext context) {
    var _catProvider=Provider.of<CategoryProvider>(context);
    Widget dialogAppBar({title, field}) {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "$title > $field",
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
      );
    }
    Widget listview({type, list, controller}) {
      return Dialog(
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              dialogAppBar(title: _catProvider.selectedItem, field: type),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            controller.text = list[i];
                          });
                          Navigator.pop(context);
                        },
                        title: Text(list[i]),
                      );
                    }),
              )
            ],
          ),
        ),
      );
    }

    String title=_catProvider.selectedItem+">"+_catProvider.selectedSub;
    validate(CategoryProvider provider) {
      if (_formKey.currentState.validate()) {
        if (provider.listUrls.isNotEmpty) {
          provider.getSellerCarFormDataToFireStore({
            'category': provider.selectedItem,
            'brand': _brandText.text,
            'price': _priceController.text,
            'title': _addTitleController.text,
            'description': _descriptionController.text,
            'user_id': services.user.uid,
            'images': provider.listUrls,
            'posted_at':DateTime.now().microsecondsSinceEpoch
          });
          Navigator.pushNamed(context, SellerReviewScreen.id);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Images required'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All the details need to be filled before submit'),
          ),
        );
      }
    }
    showBrandList(){
      showDialog(context: context, builder: (BuildContext context){
        return Dialog(
          child: Container(
            height: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                formClass.app(title: title),
                Expanded(
                  child: ListView.builder(
                      itemCount: _catProvider.doc['brands'].length,
                      itemBuilder: (_,i){

                    return ListTile(
                      onTap: (){
                        setState(() {
                          _brandText.text=_catProvider.doc['brands'][i];
                          Navigator.pop(context);
                        });
                      },
                      title:Text( _catProvider.doc['brands'][i]),
                    );
                  }),
                )
              ],
            ),
          ),
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Sell your item",style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        shape: Border(
          bottom: BorderSide(color: Colors.grey),
        ),

      ),
      body: Form(
        key: _formKey,
        child: Padding(

          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
              TextFormField(
                controller: _brandText,
                onTap: (){
                  showBrandList();
                },
                decoration: inputDecorationForTextField(context: context,labelText: 'Brands'),
              ),
                TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Price is required";
                    }
                    return null;
                  },
                  controller: _priceController,
                  decoration: inputDecorationForTextField(
                      context: context, labelText: "Price", prefixText: "Rs "),
                ),

                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  autofocus: false,
                  maxLines: 2,
                  minLines: 1,
                  maxLength: 30,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Title is required";
                    }
                    return null;
                  },
                  controller: _addTitleController,
                  decoration: inputDecorationForTextField(
                      labelText: "Add Title",
                      helperText: 'Mention the key features (eg: Brand name)',
                      context: context),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.multiline,
                  maxLength: 4000,
                  maxLines: 30,
                  minLines: 1,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Description is required";
                    }
                    return null;
                  },
                  controller: _descriptionController,
                  decoration: inputDecorationForTextField(
                    labelText: "Description",
                    helperText:
                    'Include conditions, reasons, features for selling',
                    context: context,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (_catProvider.listUrls.length > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              child: GalleryImage(
                                titileGallery: 'Uploaded images',
                                imageUrls: _catProvider.listUrls,
                              )),
                        ),
                      ],
                    ),
                  ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ImagePickerWidget();
                        });
                  },
                  child: Neumorphic(
                    child: Container(
                      height: 40,
                      child: Center(
                        child: Text('Upload Image'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
                child: NeumorphicButton(
                  style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                  onPressed: () {
                    validate(_catProvider);
                    print(_catProvider.sellerCarFormData);
                  },
                  child: Text(
                    "Next",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
