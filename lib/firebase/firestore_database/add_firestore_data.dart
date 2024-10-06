// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'package:firebase204/firebase/firestore_database/show_firestore_data.dart';
import 'package:firebase204/widgets/reuseButton.dart';
import 'package:firebase204/widgets/reuseTextFormField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({super.key});

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  // This is an variables.
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection('student');
  TextEditingController rollNoCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();
  bool isLoading = false;

  clearField() {
    setState(() {
      rollNoCont.clear();
      nameCont.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('add student screen',
              style: Utils.customTextStyle(fontFamily: 'airstrike')),
          automaticallyImplyLeading: false,
          backgroundColor: Utils.bgColor,
          centerTitle: true,
        ),
        backgroundColor: Utils.primaryColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                reuseTextFormField(
                  controller: rollNoCont,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  hintText: 'Enter Student RollNo.',
                  suffixIcon: const Icon(
                    Icons.numbers,
                    color: Colors.white,
                    size: 25,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Student RollNo.';
                    } else {
                      return null;
                    }
                  },
                ),
                reuseTextFormField(
                  controller: nameCont,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  hintText: 'Enter Student Name.',
                  suffixIcon: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 25,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Student Name.';
                    } else {
                      return null;
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    reuseButton(
                      width: 170,
                      text: 'register',
                      isLoading: isLoading,
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        String id =
                            DateTime.now().microsecondsSinceEpoch.toString();
                        await collectionReference.doc(id).set({
                          "RollNo": rollNoCont.text.toString(),
                          "Name": nameCont.text.toString(),
                        }).then((v) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (e) => ShowFirestoreData()));
                          setState(() {
                            isLoading = false;
                          });
                        }).onError((error, stackTrace) {
                          Utils.flutterToastMsg(text: error.toString());
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                    ),
                    reuseButton(
                      width: 170,
                      text: 'Reset',
                      onTap: () {
                        clearField();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
