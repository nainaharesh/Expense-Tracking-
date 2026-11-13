import 'package:expense_tracker/utils/app_assets.dart';
import 'package:expense_tracker/utils/app_colors.dart';
import 'package:expense_tracker/view/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Pops with true when the user taps Delete and false when the user taps Cancel
class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: AppColors.pureWhite,
      insetPadding: EdgeInsets.symmetric(horizontal: 34),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 56,
              width: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.colorFDE8E6,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppAssets.deleteIcon,
                width: 26,
                height: 26,
              ),
            ),
            SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: AppColors.color0F1B2D,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppColors.greyColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 25),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: CustomButton(
                    buttonColor: AppColors.pureWhite,
                    buttonText: "Cancel",
                    textColor: AppColors.color0F1B2D,
                    height: 52,
                    borderRadius: 16,
                    fontSize: 16,
                    onButtonTap: () => Navigator.pop(context, false),
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    buttonColor: AppColors.redColor,
                    buttonText: "Delete",
                    textColor: AppColors.pureWhite,
                    borderColor: AppColors.redColor,
                    height: 52,
                    borderRadius: 16,
                    fontSize: 16,
                    onButtonTap: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
