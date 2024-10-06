// ignore_for_file: use_build_context_synchronously

import 'package:firebase204/ui/sign_in/sign_in_screen.dart';
import 'package:firebase204/widgets/reuseButton.dart';
import 'package:firebase204/widgets/reuseTextFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // This is a variables as.
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
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
          title: Text('sign-up screen',
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
                    // This is name field.
                    reuseTextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      hintText: 'Enter Name...',
                      suffixIcon: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 25,
                      ),
                      validator: (v) {
                        if (v == "" || v!.isEmpty) {
                          return 'Please! Enter Name...';
                        } else {
                          return null;
                        }
                      },
                    ),
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
                    // This is conform password field.
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
                      text: 'sign-up',
                      isLoading: isLoading,
                      onTap: () async {
                        String name = nameController.text.trim();
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();
                        String conformPassword =
                            conformPasswordController.text.trim();
                        setState(() {
                          isLoading = true;
                        });
                        if (name == "" ||
                            email == "" ||
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
                              await auth
                                  .createUserWithEmailAndPassword(
                                      email: email.toString(),
                                      password: password.toString())
                                  .then((v) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (e) => const SignInScreen()));
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
                                  builder: (e) => const SignInScreen()));
                        },
                        child: Text(
                          'sign-in',
                          style: Utils.customTextStyle(
                              fontFamily: 'airstrike', color: Utils.bgColor),
                        )),
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
