import 'package:expense_tracker/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final IconData? suffixIcon;
  final void Function()? onSuffixTap;
  final bool? isObscure;
  final TextEditingController? textFieldController;
  final bool showBorder;
  final bool isNumberInput;

  const CustomTextField({
    super.key,
    this.hintText,
    this.suffixIcon,
    this.onSuffixTap,
    this.isObscure,
    this.showBorder = true,
    this.isNumberInput = false,
    this.textFieldController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textFieldController,
      keyboardType: isNumberInput ? TextInputType.number : TextInputType.text,
      obscureText: isObscure ?? false,
      decoration: InputDecoration(
        suffixIcon: InkWell(onTap: onSuffixTap, child: Icon(suffixIcon)),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: showBorder ? AppColors.whiteColor : Colors.transparent,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: showBorder ? AppColors.whiteColor : Colors.transparent,
          ),
        ),
      ),
    );
    
  }
}
