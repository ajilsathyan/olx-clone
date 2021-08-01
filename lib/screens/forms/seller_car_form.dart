import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:olx_clone/provider/category_provider.dart';
import 'package:olx_clone/screens/forms/seller_review_screen.dart';
import 'package:olx_clone/services/firebase_services.dart';
import 'package:olx_clone/widgets/image_picker_widget.dart';
import 'package:provider/provider.dart';

class SellerCarFormScreen extends StatefulWidget {
  //
  static const String id = 'seller-car-form-screen';

  @override
  _SellerCarFormScreenState createState() => _SellerCarFormScreenState();
}

class _SellerCarFormScreenState extends State<SellerCarFormScreen> {
  FirebaseServices _services = FirebaseServices();

  @override
  void initState() {
    _services.getUserData().then((value) {
      setState(() {
        _addressController.text = value['original_address'];
      });
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  var _brandController = TextEditingController();
  var _yearController = TextEditingController();
  var _priceController = TextEditingController();
  var _fuelController = TextEditingController();
  var _transmissionController = TextEditingController();
  var _kmController = TextEditingController();
  var _noOfOwnersController = TextEditingController();
  var _addTitleController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _addressController = TextEditingController();
  List<String> _fuelList = ['Diesel', 'Petrol', 'Electric', 'LPG'];
  List<String> _transmissionList = ['Manually', 'Automatic'];
  List<String> _noOfOwners = ['1', '2', '3', '4', '4+'];

  //
  validate(CategoryProvider provider) {
    if (_formKey.currentState.validate()) {
      if (provider.listUrls.isNotEmpty) {
        provider.getSellerCarFormDataToFireStore({
          'category': provider.selectedItem,
          'brand': _brandController.text,
          'price': _priceController.text,
          'year': _yearController.text,
          'fuel': _fuelController.text,
          'transmission': _transmissionController.text,
          'kilometers': _kmController.text,
          'no_of_owners': _noOfOwnersController.text,
          'title': _addTitleController.text,
          'description': _descriptionController.text,
          'user_id': _services.user.uid,
          'images': provider.listUrls,
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

  @override
  Widget build(BuildContext context) {
    var _categoryProvider = Provider.of<CategoryProvider>(context);

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            dialogAppBar(title: _categoryProvider.selectedItem, field: type),
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
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Add Some details', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        shape: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('CAR'),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Fill every items that are given below",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
                Divider(
                  thickness: 1.2,
                ),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return listview(
                              controller: _brandController,
                              list: _categoryProvider.doc['models'],
                              type: 'Brands');
                        });
                  },
                  child: TextFormField(
                    autofocus: false,
                    controller: _brandController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "please fill the required fields";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabled: false,
                      labelText: "Brand, Model, Variant*",
                      focusColor: Theme.of(context).primaryColor,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  autofocus: false,
                  controller: _yearController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Year is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Year*",
                    focusColor: Theme.of(context).primaryColor,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
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
                  decoration: InputDecoration(
                    labelText: "Price*",
                    prefixText: "Rs ",
                    focusColor: Theme.of(context).primaryColor,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  height:15,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return listview(
                              type: "Fuel",
                              list: _fuelList,
                              controller: _fuelController);
                        });
                  },
                  child: TextFormField(
                    controller: _fuelController,
                    autofocus: false,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "fuel type is required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabled: false,
                      labelText: "Fuel type*",
                      focusColor: Theme.of(context).primaryColor,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height:15,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return listview(
                              type: "Transmission",
                              list: _transmissionList,
                              controller: _transmissionController);
                        });
                  },
                  child: TextFormField(
                    autofocus: false,
                    controller: _transmissionController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "transmission type is required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabled: false,
                      labelText: "Transmission type*",
                      focusColor: Theme.of(context).primaryColor,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height:15,
                ),
                TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Kilometers  required";
                    }
                    return null;
                  },
                  controller: _kmController,
                  decoration: InputDecoration(
                    labelText: "Kilometers*",
                    prefixText: "Km ",
                    focusColor: Theme.of(context).primaryColor,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  height:15,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return listview(
                              type: "No of Owners",
                              list: _noOfOwners,
                              controller: _noOfOwnersController);
                        });
                  },
                  child: TextFormField(
                    autofocus: false,
                    controller: _noOfOwnersController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "No of owners are required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabled: false,
                      labelText: "No of Owners",
                      focusColor: Theme.of(context).primaryColor,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height:15,
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
                  decoration: InputDecoration(
                    labelText: "Add Title",
                 helperText: 'Mention the key features (eg: Brand name)',
                    focusColor: Theme.of(context).primaryColor,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  height:15,
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
                  decoration: InputDecoration(
                    labelText: "Description",
                    helperText:
                        'Include conditions, reasons, features for selling',
                    focusColor: Theme.of(context).primaryColor,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: 4,
                  minLines: 2,
                  keyboardType: TextInputType.multiline,
                  enabled: false,
                  maxLength: 250,
                  autofocus: false,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Address is required";
                    }
                    return null;
                  },
                  controller: _addressController,
                  decoration: InputDecoration(
                    focusColor: Theme.of(context).primaryColor,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),

                if (_categoryProvider.listUrls.length > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              child: GalleryImage(
                            titileGallery: 'Uploaded images',
                            imageUrls: _categoryProvider.listUrls,
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
                validate(_categoryProvider);
                print(_categoryProvider.sellerCarFormData);
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
