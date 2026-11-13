import 'dart:convert';

import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/services/local_storage/local_storage_keys.dart';

import 'package:get_storage/get_storage.dart';



List<ExpenseModel> listOfExpenses = _localExpenses();
List<ExpenseModel> _localExpenses() {
  final String? saved = GetStorage().read<String>(
    LocalStorageKeys.expenseListKey,
  );
  if (saved == null) return _sampleExpenses();
  return (jsonDecode(saved) as List)
      .map((e) => ExpenseModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();
}

Future<void> saveExpenses() {
  return GetStorage().write(
    LocalStorageKeys.expenseListKey,
    jsonEncode(listOfExpenses.map((e) => e.toJson()).toList()),
  );
}

List<ExpenseModel> _sampleExpenses() => <ExpenseModel>[

];
