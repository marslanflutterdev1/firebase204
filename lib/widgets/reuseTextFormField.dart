import 'package:flutter/material.dart';
import '../utils/utils.dart';
// ignore: must_be_immutable
class reuseTextFormField extends StatelessWidget {
  // This custom variables as.
  TextEditingController? controller;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  bool? obscureText;
  String? hintText;
  Widget? suffixIcon;
  String? Function(String?)? validator;
  int? maxLength;
  Color? fillColor;
  void Function(String)? onChanged;

  reuseTextFormField({
    super.key,
    this.controller,
    this.keyboardType =TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.hintText = 'Hint Text',
    this.suffixIcon = const Icon(Icons.computer_sharp,color: Colors.white,size: 25,),
    this.validator,
    this.maxLength,
    this.fillColor =  const Color(0xff063970),
    this.onChanged,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText!,
        validator: validator,
        maxLength: maxLength,
        autocorrect: false,
        autofocus: true,
        style: Utils.customTextStyle(fontSize: 20),
        onChanged:onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor:fillColor,
          hintText: '$hintText',
          counterText: "",
          hintStyle: Utils.customTextStyle(fontFamily: 'airstrike'),
          contentPadding:const EdgeInsets.symmetric(horizontal: 14,vertical: 16),
          suffixIcon:suffixIcon,
          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15),),
        ),
      ),
    );
  }
}
