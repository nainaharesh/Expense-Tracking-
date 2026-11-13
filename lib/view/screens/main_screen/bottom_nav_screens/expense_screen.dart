import 'dart:math';

import 'package:expense_tracker/Utils/app_colors.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/utils/app_assets.dart';
import 'package:expense_tracker/view/screens/main_screen/expense_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final TextEditingController _searchController = TextEditingController();

  // The month currently shown (only year and month are used)
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  // null means "All"
  ExpenseCategory? _selectedCategory;

  // This is the expense model
  late final List<ExpenseModel> listOfExpenses = <ExpenseModel>[
    ExpenseModel(
      expenseID: Random().nextInt(1000000),
      name: "Biryani lunch",
      category: ExpenseCategory(
        name: "Food",
        icon: AppAssets.foodIcon,
        color: AppColors.colorFFF1D6,
      ),
      createdAt: _daysAgo(0, 13, 15),
      expValue: 850,
      note: "Lunch with Hamza",
    ),
    ExpenseModel(
      expenseID: Random().nextInt(1000000),

      name: "Careem ride",
      category: ExpenseCategory(
        name: "Transport",
        icon: AppAssets.transportIcon,
        color: AppColors.colorDCEBFF,
      ),
      createdAt: _daysAgo(0, 9, 40),
      expValue: 620,
    ),
    ExpenseModel(
      expenseID: Random().nextInt(1000000),

      name: "Pharmacy",
      category: ExpenseCategory(
        name: "Health",
        icon: AppAssets.healthIcon,
        color: AppColors.colorFDE1DE,
      ),
      createdAt: _daysAgo(1, 18, 30),
      expValue: 940,
    ),
    ExpenseModel(
      expenseID: Random().nextInt(1000000),

      name: "Daraz order",
      category: ExpenseCategory(
        name: "Shopping",
        icon: AppAssets.shoppingIcon,
        color: AppColors.colorFCE1EE,
      ),
      createdAt: _daysAgo(1, 14, 10),
      expValue: 3200,
    ),
    ExpenseModel(
      expenseID: Random().nextInt(1000000),

      name: "K-Electric bill",
      category: ExpenseCategory(
        name: "Bills",
        icon: AppAssets.billIcon,
        color: AppColors.colorEADFFD,
      ),
      createdAt: _daysAgo(8, 11, 0),
      expValue: 7400,
    ),
    ExpenseModel(
      expenseID: Random().nextInt(1000000),

      name: "Cinema tickets",
      category: ExpenseCategory(
        name: "Fun",
        icon: AppAssets.funIcon,
        color: AppColors.colorD5F3EF,
      ),
      createdAt: _daysAgo(8, 20, 0),
      expValue: 1600,
    ),
    ExpenseModel(
      expenseID: Random().nextInt(1000000),

      name: "Grocery run",
      category: ExpenseCategory(
        name: "Food",
        icon: AppAssets.foodIcon,
        color: AppColors.colorFFF1D6,
      ),
      createdAt: _daysAgo(35, 17, 20),
      expValue: 2800,
    ),
  ];

  static DateTime _daysAgo(int days, int hour, int minute) {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day - days, hour, minute);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _isCurrentMonth {
    final DateTime now = DateTime.now();
    return _selectedMonth.year == now.year && _selectedMonth.month == now.month;
  }

  // Expenses after applying the month, category and search filters, newest first
  List<ExpenseModel> get _filteredExpenses {
    final String query = _searchController.text.trim().toLowerCase();

    final List<ExpenseModel> filtered = listOfExpenses.where((expense) {
      final bool sameMonth =
          expense.createdAt.year == _selectedMonth.year &&
          expense.createdAt.month == _selectedMonth.month;
      final bool sameCategory =
          _selectedCategory == null || expense.category == _selectedCategory;
      final bool matchesSearch =
          query.isEmpty ||
          expense.name.toLowerCase().contains(query) ||
          _categoryLabel(expense.category).toLowerCase().contains(query);
      return sameMonth && sameCategory && matchesSearch;
    }).toList();

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  // Groups the expenses by day, keeping the newest day first
  Map<DateTime, List<ExpenseModel>> _groupByDay(List<ExpenseModel> expenses) {
    final Map<DateTime, List<ExpenseModel>> grouped =
        <DateTime, List<ExpenseModel>>{};
    for (final ExpenseModel expense in expenses) {
      final DateTime day = DateTime(
        expense.createdAt.year,
        expense.createdAt.month,
        expense.createdAt.day,
      );
      grouped.putIfAbsent(day, () => <ExpenseModel>[]).add(expense);
    }
    return grouped;
  }

  String _formatAmount(double value) {
    return "Rs ${NumberFormat('#,##0').format(value)}";
  }

  String _dayLabel(DateTime day) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final int difference = today.difference(day).inDays;
    if (difference == 0) return "Today";
    if (difference == 1) return "Yesterday";
    return DateFormat('d MMM').format(day);
  }

  String _categoryLabel(ExpenseCategory category) {
    return category.name;
    // switch (category.name) {
    //   case ExpenseCategory.food:
    //     return "Food";
    //   case ExpenseCategory.transport:
    //     return "Transport";
    //   case ExpenseCategory.health:
    //     return "Health";
    //   case ExpenseCategory.shopping:
    //     return "Shopping";
    //   case ExpenseCategory.bill:
    //     return "Bills";
    //   case ExpenseCategory.fun:
    //     return "Fun";
    // }
  }

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
    }
  }

  void _changeMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + offset,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<ExpenseModel> expenses = _filteredExpenses;
    final Map<DateTime, List<ExpenseModel>> groupedExpenses = _groupByDay(
      expenses,
    );
    final double total = expenses.fold(0, (sum, e) => sum + e.expValue);

    return Scaffold(
      backgroundColor: AppColors.colorF4F6F8,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              SizedBox(height: 8),
              Text(
                "Expenses",
                style: TextStyle(
                  fontSize: 28,
                  letterSpacing: -0.5,
                  color: AppColors.color0F1B2D,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // This is the search field
              _searchField(),
              // This is the month selector with the total
              _monthRow(total),
              // These are the category chips
              _categoryChips(),
              Expanded(
                child: groupedExpenses.isEmpty
                    ? Center(
                        child: Text(
                          "No expenses found",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.greyColor,
                          ),
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.only(bottom: 20),
                        children: groupedExpenses.entries
                            .map((entry) => _daySection(entry.key, entry.value))
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchField() {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppColors.colorE3E8EE),
    );

    return SizedBox(
      height: 48,
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: TextStyle(fontSize: 15, color: AppColors.color0F1B2D),
        decoration: InputDecoration(
          hintText: "Search expenses",
          hintStyle: TextStyle(fontSize: 15, color: AppColors.greyColor),
          prefixIcon: Icon(Icons.search, size: 20, color: AppColors.greyColor),
          filled: true,
          fillColor: AppColors.pureWhite,
          contentPadding: EdgeInsets.zero,
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(color: AppColors.greenColor),
          ),
        ),
      ),
    );
  }

  Widget _monthRow(double total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 6,
          children: [
            _monthArrow(Icons.chevron_left, () => _changeMonth(-1)),
            Text(
              DateFormat('MMMM yyyy').format(_selectedMonth),
              style: TextStyle(
                fontSize: 15,
                color: AppColors.color0F1B2D,
                fontWeight: FontWeight.w700,
              ),
            ),
            // Cannot go past the current month
            _monthArrow(
              Icons.chevron_right,
              _isCurrentMonth ? null : () => _changeMonth(1),
            ),
          ],
        ),
        Text(
          "Total ${_formatAmount(total)}",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.greenColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _monthArrow(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Icon(
        icon,
        size: 22,
        color: onTap == null
            ? AppColors.greyColor.withValues(alpha: 0.4)
            : AppColors.color0F1B2D,
      ),
    );
  }

  Widget _categoryChips() {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _categoryChip("All", _selectedCategory == null, () {
            setState(() => _selectedCategory = null);
          }),
          // ...ExpenseCategory.values.map(
          //   (category) => _categoryChip(
          //     _categoryLabel(category),
          //     _selectedCategory == category,
          //     () => setState(() => _selectedCategory = category),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.color0F1B2D : AppColors.pureWhite,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? AppColors.color0F1B2D : AppColors.colorE3E8EE,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? AppColors.pureWhite : AppColors.color0F1B2D,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // One day: header with the day total and a card holding that day's expenses
  Widget _daySection(DateTime day, List<ExpenseModel> expenses) {
    final double dayTotal = expenses.fold(0, (sum, e) => sum + e.expValue);

    return Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: Column(
        spacing: 6,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _dayLabel(day),
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.greyColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                _formatAmount(dayTotal),
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.greyColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.colorE3E8EE),
            ),
            child: Column(
              children: [
                for (int i = 0; i < expenses.length; i++)
                  _expenseCard(expenses[i], showDivider: i != 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _categoryColor(ExpenseCategory category) {
    return category.color;
    // switch (category) {
    //   case ExpenseCategory.food:
    //     return AppColors.colorFFF1D6;
    //   case ExpenseCategory.bill:
    //     return AppColors.colorEADFFD;
    //   case ExpenseCategory.transport:
    //     return AppColors.colorDCEBFF;
    //   case ExpenseCategory.shopping:
    //     return AppColors.colorFCE1EE;
    //   case ExpenseCategory.health:
    //     return AppColors.colorFDE1DE;
    //   case ExpenseCategory.fun:
    //     return AppColors.colorD5F3EF;
    // }
  }

  String _categoryIcon(ExpenseCategory category) {
    // switch (category) {
    //   case ExpenseCategory.food:
    //     return AppAssets.foodIcon;
    //   case ExpenseCategory.bill:
    //     return AppAssets.billIcon;
    //   case ExpenseCategory.transport:
    //     return AppAssets.transportIcon;
    //   case ExpenseCategory.shopping:
    //     return AppAssets.shoppingIcon;
    //   case ExpenseCategory.health:
    //     return AppAssets.healthIcon;
    //   case ExpenseCategory.fun:
    //     return AppAssets.funIcon;
    // }
    return category.icon;
  }

  Widget _iconContainer(ExpenseCategory expenseCategory) {
    return Container(
      height: 44,
      width: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: _categoryColor(expenseCategory),
      ),
      child: SvgPicture.asset(_categoryIcon(expenseCategory)),
    );
  }

  // This is the row of a single expense inside a day card
  Widget _expenseCard(ExpenseModel expenseModel, {required bool showDivider}) {
    String formattedTime = DateFormat('h:mm a').format(expenseModel.createdAt);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openExpenseDetail(expenseModel),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          border: showDivider
              ? Border(top: BorderSide(color: AppColors.colorEEF1F4))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                spacing: 12,
                children: [
                  _iconContainer(expenseModel.category),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          expenseModel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.color0F1B2D,
                          ),
                        ),
                        Text(
                          "${_categoryLabel(expenseModel.category)} · $formattedTime",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: AppColors.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _formatAmount(expenseModel.expValue),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.color0F1B2D,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
