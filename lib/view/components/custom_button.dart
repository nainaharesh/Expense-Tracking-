import 'package:expense_tracker/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color buttonColor;
  final Color textColor;
  final String buttonText;
  final void Function()? onButtonTap;
  final Color? borderColor;
  final double height;
  final double borderRadius;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.buttonColor,
    required this.buttonText,
    this.onButtonTap, required this.textColor,
    this.borderColor,
    this.height = 50,
    this.borderRadius = 10,
    this.fontSize = 17,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onButtonTap,
      child: Container(
        height: height,
        width: double.infinity,
        // padding: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color:buttonColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? AppColors.whiteColor,
          )
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
