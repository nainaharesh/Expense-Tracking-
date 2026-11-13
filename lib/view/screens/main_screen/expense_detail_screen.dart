import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/utils/app_assets.dart';
import 'package:expense_tracker/utils/app_colors.dart';
import 'package:expense_tracker/view/components/custom_button.dart';
import 'package:expense_tracker/view/components/dialogs/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final ExpenseModel expenseModel;

  const ExpenseDetailScreen({super.key, required this.expenseModel});

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  String _formatAmount(double value) {
    return "Rs ${NumberFormat('#,##0').format(value)}";
  }

  // Asks for a confirmation and pops this screen with true if the user deletes
  Future<void> showDeleteDialog() async {
    final ExpenseModel expense = widget.expenseModel;
    final String month = DateFormat('MMMM').format(expense.createdAt);

    final bool? isConfirmed = await showDialog<bool>(
      context: context,
      barrierColor: AppColors.color0F1B2D.withValues(alpha: 0.6),
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          title: "Delete this expense?",
          message:
              "${_formatAmount(expense.expValue)} (${expense.category.name}) will be removed from your $month total. This can't be undone.",
        );
      },
    );

    if (!mounted) return;
    if (isConfirmed == true) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ExpenseModel expense = widget.expenseModel;

    return Scaffold(
      backgroundColor: AppColors.colorF4F6F8,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              CustomButton(
                buttonColor: AppColors.greenColor,
                buttonText: "Edit expense",
                textColor: AppColors.pureWhite,
                borderColor: AppColors.greenColor,
                height: 56,
                borderRadius: 18,
              ),
              CustomButton(
                buttonColor: Colors.transparent,
                buttonText: "Delete expense",
                textColor: AppColors.redColor,
                borderColor: AppColors.redColor,
                height: 56,
                borderRadius: 18,
                onButtonTap: () {
                  showDeleteDialog();
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 8),
              _header(),
              SizedBox(height: 27),
              // This is the category icon, the amount and the name
              _hero(expense),
              SizedBox(height: 28),
              // These are the details of the expense
              _detailsCard(expense),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _circleButton(AppAssets.backIcon, 22, () => Navigator.pop(context)),
        Text(
          "Expense",
          style: TextStyle(
            fontSize: 17,
            color: AppColors.color0F1B2D,
            fontWeight: FontWeight.w800,
          ),
        ),
        _circleButton(AppAssets.deleteIcon, 21, () {
          showDeleteDialog();
        }),
      ],
    );
  }

  Widget _circleButton(String icon, double iconSize, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 46,
        width: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.colorE3E8EE),
        ),
        child: SvgPicture.asset(icon, width: iconSize, height: iconSize),
      ),
    );
  }

  Widget _hero(ExpenseModel expense) {
    return Column(
      spacing: 10,
      children: [
        Container(
          height: 72,
          width: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: expense.category.color,
          ),
          // The category icons are drawn for the 22px list icon, here it is shown at 34px
          child: Transform.scale(
            scale: 34 / 22,
            child: SvgPicture.asset(expense.category.icon),
          ),
        ),
        Text(
          _formatAmount(expense.expValue),
          style: TextStyle(
            fontSize: 44,
            letterSpacing: -1,
            color: AppColors.color0F1B2D,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          expense.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.color0F1B2D,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _detailsCard(ExpenseModel expense) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.colorE3E8EE),
      ),
      child: Column(
        children: [
          _detailRow("Category", expense.category.name, showDivider: false),
          _detailRow(
            "Date",
            DateFormat('EEE, d MMM yyyy').format(expense.createdAt),
          ),
          _detailRow("Time", DateFormat('h:mm a').format(expense.createdAt)),
          _detailRow("Paid with", expense.paidWith),
          _detailRow("Note", expense.note.isEmpty ? "-" : expense.note),
        ],
      ),
    );
  }

  // This is the row of a single detail inside the details card
  Widget _detailRow(String label, String value, {bool showDivider = true}) {
    return Container(
      height: showDivider ? 55 : 54,
      decoration: BoxDecoration(
        border: showDivider
            ? Border(top: BorderSide(color: AppColors.colorEEF1F4))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 20,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.greyColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.color0F1B2D,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
