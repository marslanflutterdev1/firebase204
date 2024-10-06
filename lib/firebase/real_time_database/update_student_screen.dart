// ignore_for_file: use_build_context_synchronously

import 'package:firebase204/ui/home/home_screen.dart';
import 'package:firebase204/widgets/reuseButton.dart';
import 'package:firebase204/widgets/reuseTextFormField.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';

class UpdateStudentScreen extends StatefulWidget {
  final String? rollNo, name, degree, year, id;

  const UpdateStudentScreen(
      {super.key, this.rollNo, this.name, this.degree, this.year, this.id});

  @override
  State<UpdateStudentScreen> createState() => _UpdateStudentScreenState();
}

class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
  late DatabaseReference databaseReference;
  late TextEditingController rollNoCon;
  late TextEditingController nameCon;
  late TextEditingController degreeCon;
  late TextEditingController yearCon;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    databaseReference = FirebaseDatabase.instance.ref('students');
    rollNoCon = TextEditingController(text: widget.rollNo);
    nameCon = TextEditingController(text: widget.name);
    degreeCon = TextEditingController(text: widget.degree);
    yearCon = TextEditingController(text: widget.year);
  }

  @override
  void dispose() {
    rollNoCon.dispose();
    nameCon.dispose();
    degreeCon.dispose();
    yearCon.dispose();
    super.dispose();
  }

  clearField() {
    setState(() {
      rollNoCon.clear();
      nameCon.clear();
      degreeCon.clear();
      yearCon.clear();
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
          title: Text('Update Student',
              style: Utils.customTextStyle(fontFamily: 'airstrike')),
          backgroundColor: Utils.bgColor,
          centerTitle: true,
        ),
        backgroundColor: Utils.primaryColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  reuseTextFormField(
                    controller: rollNoCon,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    suffixIcon: const Icon(Icons.numbers,
                        color: Colors.white, size: 25),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Student RollNo.';
                      }
                      return null;
                    },
                  ),
                  reuseTextFormField(
                    controller: nameCon,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    suffixIcon:
                        const Icon(Icons.person, color: Colors.white, size: 25),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Student Name.';
                      }
                      return null;
                    },
                  ),
                  reuseTextFormField(
                    controller: degreeCon,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    suffixIcon:
                        const Icon(Icons.school, color: Colors.white, size: 25),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Student Degree Name.';
                      }
                      return null;
                    },
                  ),
                  reuseTextFormField(
                    controller: yearCon,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    suffixIcon: const Icon(Icons.timeline,
                        color: Colors.white, size: 25),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Student Degree Year.';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      reuseButton(
                        width: 170,
                        text: 'Update',
                        isLoading: isLoading,
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await databaseReference.child(widget.id!).update({
                            'RollNo': rollNoCon.text.toLowerCase(),
                            'Name': nameCon.text.toLowerCase(),
                            'Degree': degreeCon.text.toLowerCase(),
                            'Year': yearCon.text.toLowerCase(),
                          }).then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (e) => const HomeScreen()));
                            clearField();
                            setState(() {
                              isLoading = false;
                            });
                          }).catchError((error) {
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
      ),
    );
  }
}
