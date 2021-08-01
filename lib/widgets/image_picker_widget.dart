import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_clone/provider/category_provider.dart';
import 'package:olx_clone/widgets/custom_progress_bar.dart';
import 'package:provider/provider.dart';

class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  bool isImageUploading = false;
  File _image;
  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);
    Future<String> uploadFile() async {
      // _catProvider.reduceFileSize(_image);
      File file = File(_image.path);
      String imageName =
          "ProductImage/${DateTime.now().microsecondsSinceEpoch}";
      String downloadedUrl;

      try {
        await FirebaseStorage.instance.ref(imageName).putFile(file);
        downloadedUrl =
            await FirebaseStorage.instance.ref(imageName).getDownloadURL();
        if (downloadedUrl != null) {
          setState(() {
            _image = null;
          });
          print(downloadedUrl);
        }
      } on FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Canceled'),
          ),
        );
      }
      return downloadedUrl;
    }

    return Dialog(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                  actions: [
                    if (_image != null)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _image = null;
                          });
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      ),
                  ],
                  elevation: 0.75,
                  backgroundColor: Colors.white,
                  title: Text(
                    "Upload images",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  )),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: FittedBox(
                        child: _image == null
                            ? Icon(
                                CupertinoIcons.photo_on_rectangle,
                                color: Colors.grey,
                              )
                            : SingleChildScrollView(
                                child: Row(
                                  children: [
                                    Image.file(_image),
                                  ],
                                ),
                              )),
                  ),
                ],
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: getImageFromGallery,
                        style: NeumorphicStyle(
                            color: Theme.of(context).primaryColor),
                        child: Text(
                          "Open gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: getImageFromCamera,
                        style: NeumorphicStyle(
                            color: Theme.of(context).primaryColor),
                        child: Text(
                          "Open Camera",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: () {
                          setState(() {
                            isImageUploading = true;
                          });
                          uploadFile().then((url) {
                            if (url != null) {
                              _catProvider.getDownloadedImageUrls(url);
                              setState(() {
                                isImageUploading = false;
                              });
                            }
                          });
                        },
                        style: NeumorphicStyle(
                            color: Theme.of(context).primaryColor),
                        child: isImageUploading
                            ? Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              )
                            : Text(
                                _catProvider.listUrls.length > 0
                                    ? "Upload more images"
                                    : "Upload Image",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
