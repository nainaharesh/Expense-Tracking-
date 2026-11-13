import 'package:expense_tracker/model/expense_model.dart';


class ExpenseModel {
  final int expenseID;
  final String name;
  final ExpenseCategory category;
  final DateTime createdAt;
  final double expValue;
  final String paidWith;
  final String note;

  const ExpenseModel({
    required this.name,
    required this.category,
    required this.createdAt,
    required this.expValue,
    this.paidWith = "Cash",
    this.note = "",
    required this.expenseID,
  });

  Map<String, dynamic> toJson() => {
    'expenseID': expenseID,
    'name': name,
    'category': category.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'expValue': expValue,
    'paidWith': paidWith,
    'note': note,
  };
}
