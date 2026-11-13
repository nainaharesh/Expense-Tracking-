import 'package:expense_tracker/Utils/app_colors.dart';
import 'package:expense_tracker/model/expense_model.dart';

import 'package:expense_tracker/utils/global.dart';
import 'package:expense_tracker/view/screens/main_screen/expense_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // This is the expense model
  // List<ExpenseModel> listOfExpenses = <ExpenseModel>[
  //   ExpenseModel(
  //     name: "Biryani",
  //     category: ExpenseCategory(
  //       name: "Food",
  //       icon: AppAssets.foodIcon,
  //       color: AppColors.colorFFF1D6,
  //     ),
  //     createdAt: DateTime.now(),
  //     expValue: 10,
  //   ),
  //   ExpenseModel(
  //     name: "KE bill",
  //     category: ExpenseCategory(
  //       name: "Bills",
  //       icon: AppAssets.billIcon,
  //       color: AppColors.colorEADFFD,
  //     ),
  //     createdAt: DateTime.now(),
  //     expValue: 10,
  //   ),
  //   ExpenseModel(
  //     name: "Car Fuel",
  //     category: ExpenseCategory(
  //       name: "Transport",
  //       icon: AppAssets.transportIcon,
  //       color: AppColors.colorDCEBFF,
  //     ),
  //     createdAt: DateTime.now(),
  //     expValue: 10,
  //   ),
  //   ExpenseModel(
  //     name: "CBC blood test",
  //     category: ExpenseCategory(
  //       name: "Health",
  //       icon: AppAssets.healthIcon,
  //       color: AppColors.colorFDE1DE,
  //     ),
  //     createdAt: DateTime.now(),
  //     expValue: 10,
  //   ),
  // ];

  // Opens the detail screen, it pops with true when the expense was deleted
  Future<void> _openExpenseDetail(ExpenseModel expenseModel) async {
    final bool? isDeleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseDetailScreen(expenseModel: expenseModel),
      ),
    );

    if (!mounted) return;
    if (isDeleted == true) {
      setState(() {
        listOfExpenses.remove(expenseModel);
      });
      saveExpenses();
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good morning,",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.greyColor,
                        ),
                      ),
                      Text(
                        "Ayesha",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.color0F1B2D,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.colorDCF2E8,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "A",
                      style: TextStyle(
                        color: AppColors.greenColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // This is the spending card
              _spendingCard(),
              listOfExpenses.isEmpty
                  ? SizedBox()
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.color0F1B2D,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "See all",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.greenColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
              ListView.separated(
                itemCount: listOfExpenses.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _expenseCard(listOfExpenses[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconContainer(ExpenseCategory expenseCategory) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: expenseCategory.color,
      ),
      child: SvgPicture.asset(expenseCategory.icon),
    );
    // switch (expenseCategory) {
    //   case ExpenseCategory.food:
    //     return Container(
    //       padding: EdgeInsets.all(12),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(12),
    //         color: AppColors.colorFFF1D6,
    //       ),
    //       child: SvgPicture.asset(AppAssets.foodIcon),
    //     );
    //
    //     // Body of value1
    //     break;
    //
    //   case ExpenseCategory.bill:
    //     return Container(
    //       padding: EdgeInsets.all(12),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(12),
    //         color: AppColors.colorEADFFD,
    //       ),
    //       child: SvgPicture.asset(AppAssets.billIcon),
    //     );
    //   case ExpenseCategory.transport:
    //     return Container(
    //       padding: EdgeInsets.all(12),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(12),
    //         color: AppColors.colorDCEBFF,
    //       ),
    //       child: SvgPicture.asset(AppAssets.transportIcon),
    //     );
    //   case ExpenseCategory.shopping:
    //     return Container(
    //       padding: EdgeInsets.all(12),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(12),
    //         color: AppColors.colorFCE1EE,
    //       ),
    //       child: SvgPicture.asset(AppAssets.shoppingIcon),
    //     );
    //   case ExpenseCategory.health:
    //     return Container(
    //       padding: EdgeInsets.all(12),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(12),
    //         color: AppColors.colorFDE1DE,
    //       ),
    //       child: SvgPicture.asset(AppAssets.healthIcon),
    //     );
    //
    //   // Add more cases as needed
    //
    //   default:
    //     return Container(
    //       padding: EdgeInsets.all(12),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(12),
    //         color: AppColors.colorFFF1D6,
    //       ),
    //       child: SvgPicture.asset(AppAssets.healthIcon),
    //     );
    //
    //     // Body of default case
    //     break;
    // }
  }

  // This is the list tile of the list view of expenses
  Widget _expenseCard(ExpenseModel expenseModel) {
    String formattedDate = DateFormat(
      'yyyy-MM-dd, HH:mm a',
    ).format(expenseModel.createdAt);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openExpenseDetail(expenseModel),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13),
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 15,
              children: [
                _iconContainer(expenseModel.category),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      expenseModel.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.color0F1B2D,
                      ),
                    ),
                    Text(
                      "Food · ${formattedDate}",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              expenseModel.expValue.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.color0F1B2D,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _spendingCard() {
 
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      height: 140.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.greenColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "October spending",
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "Rs 40,000",
            style: TextStyle(
              fontSize: 38.sp,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          LinearProgressIndicator(
            color: AppColors.whiteColor,
            backgroundColor: AppColors.whiteColor.withValues(alpha: 0.2),
            value: 0.3,
            // semanticsLabel: 'Linear progress indicator',
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "67% of Rs 60,000 budget",
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "Rs 20,000 left",
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
