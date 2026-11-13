import 'dart:math';

import 'package:expense_tracker/Utils/app_colors.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/utils/app_assets.dart';
import 'package:expense_tracker/utils/global.dart';
import 'package:expense_tracker/view/components/custom_button.dart';
import 'package:expense_tracker/view/components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../components/bottom_sheets/show_category_grid_view_sheet.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  Widget _iconContainer(ExpenseCategory expenseCategory) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: expenseCategory.color,
      ),
      child: SvgPicture.asset(expenseCategory.icon),
    );
  }

  DateTime? selectedDate= DateTime.now();
  String formattedDate = "Select Date";

  List<ExpenseCategory> listOfCategories = <ExpenseCategory>[
    ExpenseCategory(
      name: "Food",
      icon: AppAssets.foodIcon,
      color: AppColors.colorFFF1D6,
      isSelected: true,
    ),
    ExpenseCategory(
      name: "Transport",
      icon: AppAssets.transportIcon,
      color: AppColors.colorDCEBFF,
    ),
    ExpenseCategory(
      name: "Health",
      icon: AppAssets.healthIcon,
      color: AppColors.colorFDE1DE,
    ),
    ExpenseCategory(
      name: "Shopping",
      icon: AppAssets.shoppingIcon,
      color: AppColors.colorFCE1EE,
    ),
    ExpenseCategory(
      name: "Bills",
      icon: AppAssets.billIcon,
      color: AppColors.colorEADFFD,
    ),
    ExpenseCategory(
      name: "Fun",
      icon: AppAssets.funIcon,
      color: AppColors.colorD5F3EF,
    ),
  ];

  ExpenseCategory selectedCategory = ExpenseCategory(
    name: "Food",
    icon: AppAssets.foodIcon,
    color: AppColors.colorFFF1D6,
    isSelected: true,
  );

  // List<ExpenseCategory> listOfExpenseCategory = <ExpenseCategory>[
  //   ExpenseCategory.health,
  //   ExpenseCategory.health,
  //   ExpenseCategory.health,
  //   ExpenseCategory.health,
  //   ExpenseCategory.health,
  // ];

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2021, 7, 25),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );

    setState(() {
      selectedDate = pickedDate;
      formattedDate = DateFormat(
        'yyyy-MMM-dd',
      ).format(pickedDate ?? DateTime.now());
    });
  }

  void showGridViewBottomSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ShowCategoryGridViewSheet(listOfCategory: listOfCategories);
      },
    );
    print("-----Selected Category From bottom Sheet-----------");
    print(result.name.toString());
    selectedCategory = ExpenseCategory(
      name: result.name,
      icon: result.icon,
      color: result.color,
    );
    setState(() {});
  }

  TextEditingController expenseTextEditingController = TextEditingController();
  TextEditingController expenseNameTextEditingController = TextEditingController();

  addExpenseToList() {
    listOfExpenses.add(
      ExpenseModel(
        expenseID: Random().nextInt(1000000),
        name: expenseNameTextEditingController.text,
        category: selectedCategory,
        createdAt: selectedDate??DateTime.now(),
        expValue: double.parse(expenseTextEditingController.text),
      ),
    );

    Navigator.pop(context);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CustomButton(
          buttonColor: AppColors.greenColor,
          buttonText: "Save Expense",
          textColor: AppColors.pureWhite,
          onButtonTap: (){
            addExpenseToList();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.whiteColor),
                      ),
                      child: Icon(Icons.close),
                    ),
                  ),
                  Text(
                    "Add expense",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 40),
                ],
              ),
              Text(
                "Amount",
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),

              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    "Rs",
                    style: TextStyle(
                      color: AppColors.greyColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: CustomTextField(
                      showBorder: false,
                      isNumberInput: true,
                      textFieldController: expenseTextEditingController,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 20,
                            children: [
                              SizedBox(
                                width: 70,

                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                    color: AppColors.greyColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                child: CustomTextField(
                                  hintText: "Type Name here....",
                                  showBorder: false,
                                  textFieldController: expenseNameTextEditingController,

                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          // Icon(
                          //   Icons.arrow_forward_ios,
                          //   size: 20,
                          //   color: AppColors.greyColor,
                          // ),
                        ],
                      ),
                    ),

                    Divider(color: AppColors.whiteColor),
                    SizedBox(
                      height: 50,
                      child: InkWell(
                        onTap: () {
                          showGridViewBottomSheet();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 20,
                              children: [
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    "Category",
                                    style: TextStyle(
                                      color: AppColors.greyColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Row(
                                  spacing: 10,
                                  children: [
                                    _iconContainer(
                                      selectedCategory,
                                      // ExpenseCategory(
                                      //   name: "Health",
                                      //   icon: AppAssets.healthIcon,
                                      //   color: AppColors.colorFDE1DE,
                                      // ),
                                    ),
                                    Text(
                                      selectedCategory.name,
                                      style: TextStyle(
                                        // color: AppColors.greyColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: AppColors.greyColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: AppColors.whiteColor),
                    SizedBox(
                      height: 50,

                      child: InkWell(
                        onTap: () {
                          _selectDate();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 20,
                              children: [
                                SizedBox(
                                  width: 70,

                                  child: Text(
                                    "Date",
                                    style: TextStyle(
                                      color: AppColors.greyColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Text(
                                  // "Today, 2 Oct 2026",
                                  formattedDate,
                                  style: TextStyle(
                                    // color: AppColors.greyColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: AppColors.greyColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: AppColors.whiteColor),
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 20,
                            children: [
                              SizedBox(
                                width: 70,

                                child: Text(
                                  "Notes",
                                  style: TextStyle(
                                    color: AppColors.greyColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                child: CustomTextField(
                                  hintText: "Lunch with Hamza",
                                  showBorder: false,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          // Icon(
                          //   Icons.arrow_forward_ios,
                          //   size: 20,
                          //   color: AppColors.greyColor,
                          // ),
                        ],
                      ),
                    ),
                    // Divider(color: AppColors.whiteColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
