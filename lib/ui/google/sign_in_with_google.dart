// ignore_for_file: use_build_context_synchronously

import 'package:firebase204/ui/home/home_screen.dart';
import 'package:firebase204/widgets/reuseButton.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';

class SignInWithGoogle extends StatefulWidget {
  const SignInWithGoogle({super.key});

  @override
  State<SignInWithGoogle> createState() => _SignInWithGoogleState();
}

class _SignInWithGoogleState extends State<SignInWithGoogle> {
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
          title: Text(
            'Sign-in with Google',
            style: Utils.customTextStyle(fontFamily: 'airstrike'),
          ),
          backgroundColor: Utils.bgColor,
          centerTitle: true,
        ),
        backgroundColor: Utils.primaryColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Click Google button',
                  style: Utils.customTextStyle(fontFamily: 'airstrike'),
                ),
                reuseButton(
                  text: 'Google Sign-In',
                  isLoading: isLoading,
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    // This is instance of google sign-in.
                    final GoogleSignIn googleSignIn = GoogleSignIn();
                    // This line show all email account who exist in user account.
                    final GoogleSignInAccount? googleSignInAccount =
                        await googleSignIn.signIn();
                    try {
                      if (googleSignInAccount != null) {
                        // If user email account is not null then authenticate kar lo or ya user email conform kar lo.
                        final GoogleSignInAuthentication
                            googleSignInAuthentication =
                            await googleSignInAccount.authentication;
                        // If user email authenticate okk then access idToken and accessToken from user email who authenticate.
                        final AuthCredential credential =
                            GoogleAuthProvider.credential(
                          accessToken: googleSignInAuthentication.accessToken,
                          idToken: googleSignInAuthentication.idToken,
                        );
                        // Finally sign in credential and move to other screen as.
                        await auth
                            .signInWithCredential(credential)
                            .then((value) {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                          setState(() {
                            isLoading = false;
                          });
                        });
                      }
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
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
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
