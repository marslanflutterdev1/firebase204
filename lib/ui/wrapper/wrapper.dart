import 'dart:async';

import 'package:firebase204/ui/home/home_screen.dart';
import 'package:firebase204/ui/sign_in/sign_in_screen.dart';
import 'package:firebase204/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  Wrapper({super.key});
 Future<FirebaseApp> initializationApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializationApp,
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> asyncSnapshot){
          // if any kind of error then this running.
          if(asyncSnapshot.hasError){
             Utils.flutterToastMsg(text: 'Error In The App e.g: \n ${asyncSnapshot.error.toString()}');
          }
          // if all is done then this running.
          if(asyncSnapshot.connectionState == ConnectionState.done){
            return StreamBuilder(
               // Below line basically check user exist or not.
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, AsyncSnapshot<User?> streamAsyncSnapshot){
                  // if any kind of error then this running.
                  if(streamAsyncSnapshot.hasError){
                    Utils.flutterToastMsg(text: 'Error In The App e.g: \n ${streamAsyncSnapshot.error.toString()}');
                  }
                  // if user is active then this running.
                  if(streamAsyncSnapshot.connectionState == ConnectionState.active){
                    User? user =  streamAsyncSnapshot.data;
                    if(user != null){
                      return  const HomeScreen();
                    }else{
                      return const SignInScreen();
                    }
                  }

                  // At the end this running.
                  return Scaffold(
                    extendBodyBehindAppBar: true,
                    backgroundColor: Utils.bgColor,
                    body:Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(child: Text('check authentication application',style: Utils.customTextStyle(fontFamily: 'airstrike'),),),
                          const SizedBox(height: 8),
                          CircularProgressIndicator(strokeWidth: 4,color: Utils.textColor,)
                        ],
                      ),
                    ),
                  );
                }
            );
          }

          // At the end this running.
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Utils.bgColor,
            body:Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Text('initialization-app',style: Utils.customTextStyle(fontFamily: 'airstrike'),),),
                  const SizedBox(height: 8),
                  CircularProgressIndicator(strokeWidth: 4,color: Utils.textColor,)
                ],
              ),
            ),
          );
        }
    );
  }
}
