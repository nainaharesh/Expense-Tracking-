import 'package:expense_tracker/Utils/app_colors.dart';

import 'package:expense_tracker/view/screens/main_screen/add_expense.dart';
import 'package:expense_tracker/view/screens/main_screen/bottom_nav_screens/expense_screen.dart';
import 'package:expense_tracker/view/screens/main_screen/bottom_nav_screens/home_screen.dart';
import 'package:expense_tracker/view/screens/main_screen/bottom_nav_screens/setting_screen.dart';
import 'package:expense_tracker/view/screens/main_screen/bottom_nav_screens/summary_screen.dart';
import 'package:flutter/material.dart';


class BottomNavHomeScreen extends StatefulWidget {
  const BottomNavHomeScreen({super.key});

  @override
  State<BottomNavHomeScreen> createState() => _BottomNavHomeScreenState();
}

class _BottomNavHomeScreenState extends State<BottomNavHomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // This is a getter (not a field) so new screen widgets are created on every build.
  // If the same widget objects were reused, Flutter would skip rebuilding them
  // and the Home list would not refresh when setState is called here.
  // Do not make these const for the same reason.
  List get listOfScreens => [
    HomeScreen(),
    ExpenseScreen(),
    SummaryScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.m,
      floatingActionButton: InkWell(
        onTap: () async  {
           await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(
              ),
            ),
          );
          // The Add screen is closed now, rebuild so the new expense shows up
          // if (!mounted) return;
          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.all(15),
          // height: 70,
          // width: 50,
          decoration: BoxDecoration(
            color:AppColors.greenColor,
            shape: BoxShape.circle,

          ),
          child: Icon(Icons.add,color: AppColors.pureWhite,size: 35,),

        ),
      ),
      body: listOfScreens[_selectedIndex],
      // floatingActionButton: Icon(Icons.add),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Expense',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.summarize_outlined), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.greenColor,
        unselectedItemColor: AppColors.greyColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
