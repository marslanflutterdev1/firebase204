// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, use_build_context_synchronously

import 'package:firebase204/ui/home/home_screen.dart';
import 'package:firebase204/widgets/reuseButton.dart';
import 'package:firebase204/widgets/reuseTextFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';

class VerifyOTP extends StatefulWidget {
  String? verificationID;
  VerifyOTP({super.key, this.verificationID});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  // This is variables.
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('verify otp',
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
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  hintText: 'Enter OTP',
                  maxLength: 6,
                  suffixIcon: const Icon(
                    Icons.code,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                reuseButton(
                  text: 'verify otp',
                  isLoading: isLoading,
                  onTap: () async {
                    String OTP = otpController.text.trim();
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: widget.verificationID.toString(),
                            smsCode: OTP);
                    if (OTP == "") {
                      Utils.flutterToastMsg(text: 'Please! Fills OTP...');
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        await auth
                            .signInWithCredential(credential)
                            .then((value) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (e) => HomeScreen()));
                          setState(() {
                            isLoading = false;
                          });
                        });
                      } on FirebaseAuthException catch (ex) {
                        Utils.flutterToastMsg(text: ex.toString());
                        setState(() {
                          isLoading = false;
                        });
                      } catch (ex) {
                        Utils.flutterToastMsg(text: ex.toString());
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
