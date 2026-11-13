import 'package:flutter/material.dart';

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
    this.note = "", required this.expenseID,
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

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
    expenseID: json['expenseID'] as int,
    name: json['name'] as String,
    category: ExpenseCategory.fromJson(
      Map<String, dynamic>.from(json['category'] as Map),
    ),
    createdAt: DateTime.parse(json['createdAt'] as String),
    expValue: (json['expValue'] as num).toDouble(),
    paidWith: json['paidWith'] as String? ?? "Cash",
    note: json['note'] as String? ?? "",
  );
}



class ExpenseCategory {
final String name;
final String icon;
final Color color;
 bool isSelected;


 ExpenseCategory({
required this.name, required this.icon, required this.color, this.isSelected=false,

});

  Map<String, dynamic> toJson() => {
    'name': name,
    'icon': icon,
    'color': color.toARGB32(),
  };

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) =>
      ExpenseCategory(
        name: json['name'] as String,
        icon: json['icon'] as String,
        color: Color(json['color'] as int),
      );
}