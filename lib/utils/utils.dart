import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// This is custom class utilization of all need thing.
class Utils {
  // This is custom colors.
  static Color? bgColor = const Color(0xff063970);
  static Color? primaryColor = const Color(0xff69bdd2);
  static Color? textColor = const Color(0xffffffff);

// This is custom text style.
  static TextStyle customTextStyle({
    Color? color = Colors.white,
    double? fontSize = 25,
    FontWeight? fontWeight = FontWeight.normal,
    String? fontFamily,
  }) {
    return TextStyle(
      color: color,
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
  // This is flutter toast msg.
 static Future<void> flutterToastMsg({required String text}){
    return Fluttertoast.showToast(
      msg: text.toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 20,
      backgroundColor: Utils.bgColor,
      textColor: Utils.textColor,
      fontSize: 16.0
  );
 }

  }

