// ignore_for_file: use_build_context_synchronously

import 'package:firebase204/ui/google/sign_in_with_google.dart';
import 'package:firebase204/ui/phone/verify_phone_number.dart';
import 'package:firebase204/ui/sign_up/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import '../../widgets/reuseButton.dart';
import '../../widgets/reuseTextFormField.dart';
import '../home/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // This is a variables.
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isTab1 = false;
  bool isTab2 = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('sign-in screen',
              style: Utils.customTextStyle(fontFamily: 'airstrike')),
          backgroundColor: Utils.bgColor,
          centerTitle: true,
        ),
        backgroundColor: Utils.primaryColor,
        body: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // This is email field.
                    reuseTextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      hintText: 'Enter Email...',
                      suffixIcon: const Icon(
                        Icons.email,
                        color: Colors.white,
                        size: 25,
                      ),
                      validator: (v) {
                        if (v == "" || v!.isEmpty) {
                          return 'Please! Enter Email...';
                        } else {
                          return null;
                        }
                      },
                    ),
                    // This is password field.
                    reuseTextFormField(
                      controller: passwordController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      textInputAction: TextInputAction.next,
                      hintText: 'Enter Password...',
                      obscureText: isTab1,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isTab1 = !isTab1;
                          });
                        },
                        icon: isTab1
                            ? const Icon(
                                Icons.visibility,
                                color: Colors.white,
                                size: 25,
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: Colors.white,
                                size: 25,
                              ),
                      ),
                      validator: (v) {
                        if (v == "" || v!.isEmpty) {
                          return 'Please! Enter Password...';
                        } else {
                          return null;
                        }
                      },
                    ),
                    reuseTextFormField(
                      controller: conformPasswordController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      textInputAction: TextInputAction.done,
                      hintText: 'Enter Password...',
                      obscureText: isTab2,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isTab2 = !isTab2;
                          });
                        },
                        icon: isTab2
                            ? const Icon(
                                Icons.visibility,
                                color: Colors.white,
                                size: 25,
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: Colors.white,
                                size: 25,
                              ),
                      ),
                      validator: (v) {
                        if (v == "" || v!.isEmpty) {
                          return 'Please! Enter Password...';
                        } else {
                          return null;
                        }
                      },
                    ),

                    reuseButton(
                      text: 'sign-in',
                      isLoading: isLoading,
                      onTap: () async {
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();
                        String conformPassword =
                            conformPasswordController.text.trim();
                        setState(() {
                          isLoading = true;
                        });
                        if (email == "" ||
                            password == "" ||
                            conformPassword == "") {
                          Utils.flutterToastMsg(
                              text: 'Please! Fills All Necessary Details...');
                          setState(() {
                            isLoading = false;
                          });
                        } else if (password != conformPassword) {
                          Utils.flutterToastMsg(
                              text: 'Password Not Matching...');
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          if (_formKey.currentState != null ||
                              _formKey.currentState!.validate()) {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              await _auth
                                  .signInWithEmailAndPassword(
                                      email: email.toString(),
                                      password: password.toString())
                                  .then((v) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (e) => const HomeScreen()));
                                Utils.flutterToastMsg(text: 'successfully');
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            } on FirebaseAuthException catch (e) {
                              Utils.flutterToastMsg(
                                  text:
                                      'FirebaseAuthException error e.g: \n ${e.toString()}');
                              setState(() {
                                isLoading = false;
                              });
                            } catch (e) {
                              Utils.flutterToastMsg(
                                  text: 'Catch error e.g: \n ${e.toString()}');
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        }
                      },
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (e) => const SignUpScreen()));
                        },
                        child: Text(
                          'sign-up',
                          style: Utils.customTextStyle(
                              fontFamily: 'airstrike', color: Utils.bgColor),
                        )),
                    // const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (e) =>
                                          const SignInWithGoogle()));
                            },
                            child: Text(
                              'google',
                              style: Utils.customTextStyle(
                                  color: Utils.bgColor,
                                  fontFamily: 'airstrike'),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (e) => VerifyPhoneNumber()));
                            },
                            child: Text(
                              'phone',
                              style: Utils.customTextStyle(
                                  color: Utils.bgColor,
                                  fontFamily: 'airstrike'),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
