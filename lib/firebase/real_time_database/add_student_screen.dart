// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase204/ui/home/home_screen.dart';
import 'package:firebase204/widgets/reuseButton.dart';
import 'package:firebase204/widgets/reuseTextFormField.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  // This is an variables.
  TextEditingController rollNoCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();
  TextEditingController degreeCont = TextEditingController();
  TextEditingController yearCont = TextEditingController();
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('students');
  bool isLoading = false;

  clearField() {
    setState(() {
      rollNoCont.clear();
      nameCont.clear();
      degreeCont.clear();
      yearCont.clear();
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
                  textInputAction: TextInputAction.next,
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
                reuseTextFormField(
                  controller: degreeCont,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  hintText: 'Enter Degree Name.',
                  suffixIcon: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 25,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Student Degree Name.';
                    } else {
                      return null;
                    }
                  },
                ),
                reuseTextFormField(
                  controller: yearCont,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  hintText: 'Enter Degree Year.',
                  suffixIcon: const Icon(
                    Icons.timeline,
                    color: Colors.white,
                    size: 25,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Student Degree Year.';
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
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        String id =
                            DateTime.now().microsecondsSinceEpoch.toString();
                        databaseReference.child(id).set({
                          'id': id,
                          'RollNo': rollNoCont.text.trim().toString(),
                          'Name': nameCont.text.trim().toString(),
                          'Degree': degreeCont.text.trim().toString(),
                          'Year': yearCont.text.trim().toString()
                        }).then((value) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (e) => HomeScreen()));
                          clearField();
                          setState(() {
                            isLoading = false;
                          });
                        }).onError((error, stacktrace) {
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
