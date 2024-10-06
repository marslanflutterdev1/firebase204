import 'package:flutter/material.dart';
import '../utils/utils.dart';

class reuseButton extends StatelessWidget {
  // This variables and its initialization.
  final void Function()? onTap;
  final String? text;
  final bool isLoading;
  final double? width;
  final double? height;
  // This is a constructor.
  const reuseButton({
    super.key,
    this.onTap,
    this.text = 'button',
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 68,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: Utils.bgColor, borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: isLoading
                ? CircularProgressIndicator(
                    strokeWidth: 4,
                    color: Utils.textColor,
                  )
                : Text(
                    '$text',
                    style: Utils.customTextStyle(fontFamily: 'airstrike'),
                  ),
          ),
        ),
      ),
    );
  }
}
