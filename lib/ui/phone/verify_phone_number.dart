// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:firebase204/ui/phone/verifyOTP.dart';
import 'package:firebase204/widgets/reuseButton.dart';
import 'package:firebase204/widgets/reuseTextFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class VerifyPhoneNumber extends StatefulWidget {
   VerifyPhoneNumber({super.key});

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  // This is variables.
  TextEditingController phoneController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar:AppBar(title: Text('sign-in phone',style: Utils.customTextStyle(fontFamily: 'airstrike')),
          backgroundColor: Utils.bgColor,
          centerTitle: true,
        ) ,
        backgroundColor: Utils.primaryColor,
        body: SafeArea(
          child:  Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              reuseTextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                hintText: 'Phone Number',
                suffixIcon:  const Icon(Icons.phone,color: Colors.white,size: 25,),
              ),
             reuseButton(
               text: 'send otp',
               isLoading: isLoading,
               onTap: ()async{
                 String phone = phoneController.text.trim();
                 if(phone == ""){
                   Utils.flutterToastMsg(text: 'Please! Fills The Phone Number...');
                   setState(() {
                     isLoading = false;
                   });
                 }else{
                   try{
                     setState(() {
                       isLoading = true;
                     });
                     await auth.verifyPhoneNumber(
                       phoneNumber: phoneController.text.trim(),
                       verificationCompleted: (credential){
                         setState(() {
                           isLoading = false;
                         });
                       },
                       verificationFailed: (ex){Utils.flutterToastMsg(text: 'Error e.g: \n ${ex.toString()}');
                        setState(() {
                         isLoading = false;
                        });
                       },
                       codeSent: (String verificationID, int? tokenID){
                         Navigator.push(context, MaterialPageRoute(builder: (e)=>VerifyOTP(verificationID: verificationID),),);
                         setState(() {
                           isLoading = false;
                         });
                       },
                       codeAutoRetrievalTimeout: (String verificationID){
                         setState(() {
                           isLoading = false;
                         });
                       },
                       timeout:const Duration(seconds: 60),
                     );
                   }on FirebaseAuthException catch(ex){
                     Utils.flutterToastMsg(text: ex.toString());
                     setState(() {
                       isLoading = false;
                     });
                   }catch(ex){
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
