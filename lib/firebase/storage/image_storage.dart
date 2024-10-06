import 'dart:io';

import 'package:firebase204/widgets/reuseButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/utils.dart';

class ImageStorage extends StatefulWidget {
  const ImageStorage({super.key});

  @override
  State<ImageStorage> createState() => _ImageStorageState();
}

class _ImageStorageState extends State<ImageStorage> {
  bool isLoading = false;
  File? _file;
  ImagePicker imagePicker = ImagePicker();
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  Future getImageFromGallery()async{
  XFile? pickFile = await imagePicker.pickImage(source: ImageSource.gallery,imageQuality: 80);
  setState(() {
    if(pickFile != null){
      _file = File(pickFile.path);
    }else{
      Utils.flutterToastMsg(text: 'No Image Found');
    }
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text('sign-in screen',style: Utils.customTextStyle(fontFamily: 'airstrike')),
        backgroundColor: Utils.bgColor,
        centerTitle: true,
      ),
      backgroundColor: Utils.primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){getImageFromGallery();},
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Utils.bgColor,
                    border: Border.all(color: Utils.textColor!, width: 4),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(child:_file != null ? ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.file(_file!.absolute,width: 200,height: 200,fit: BoxFit.cover,)) :Text('click pick image',style: Utils.customTextStyle(fontSize: 18),),),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            reuseButton(
              text: "upload image",
              isLoading: isLoading,
              onTap: ()async{
                setState(() {
                  isLoading = true;
                });
                String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
                DatabaseReference databaseRef = firebaseDatabase.ref('image');
                Reference ref = FirebaseStorage.instance.ref('node').child('/Folder/File : $uniqueFileName}');
                UploadTask uploadTask = ref.putFile(_file!.absolute);
                await Future.value(uploadTask).then((value) async {
                  String getDownloadUrl = await ref.getDownloadURL();
                  Utils.flutterToastMsg(text: "Successfully");
                  databaseRef.child(uniqueFileName).set({
                  "id":uniqueFileName,
                  "url": getDownloadUrl.toString()
                  }).then((value){
                    Utils.flutterToastMsg(text: "Successfully Database Store Url");
                    setState(() {
                      isLoading = false;
                    });
                  }).onError((error, stackTrace){
                    Utils.flutterToastMsg(text: error.toString());
                    setState(() {
                      isLoading = false;
                    });
                  });
                   getDownloadUrl;
                  setState(() {
                    isLoading = false;
                  });
                }).onError((error, stackTrace){
                  Utils.flutterToastMsg(text: error.toString());
                  setState(() {
                    isLoading = false;
                  });
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
