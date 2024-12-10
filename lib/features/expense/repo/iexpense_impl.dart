import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:expense_todo_app/features/expense/data/iexpense_facade.dart';
import 'package:expense_todo_app/features/expense/data/model/expense_model.dart';
import 'package:expense_todo_app/general/failure/failures.dart';
import 'package:expense_todo_app/general/utils/firebase_collection.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IexpenseFacade)
class IexpenseImpl implements IexpenseFacade {
  final FirebaseFirestore firestore;
  IexpenseImpl(this.firestore);
  DocumentSnapshot? lastDocument;
  bool noMoreData = false;

  @override
  Future<Either<MainFailure, ExpenseModel>> addExpenses(
      {required ExpenseModel expenseModel}) async {
    try {
      final expenseRef = firestore.collection(FirebaseCollection.expense);
      final id = expenseRef.doc().id;
      final expense = expenseModel.copyWith(id: id);
      await expenseRef.doc(id).set(expense.toMap());

      return right(expense);
    } catch (e) {
      return left(MainFailure.serverFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<MainFailure, List<ExpenseModel>>> fetchExpenses() async {
    if (noMoreData) return right([]);
    try {
      Query query =
          firestore.collection('expense').orderBy('title', descending: false);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.limit(10).get();
      log('message');
      if (querySnapshot.docs.length < 10) {
        noMoreData = true;
      } else {
        lastDocument = querySnapshot.docs.last;
      }

      final newList = querySnapshot.docs
          .map(
              (exp) => ExpenseModel.fromMap(exp.data() as Map<String, dynamic>))
          .toList();

      return right(newList);
    } catch (e) {
      return left(MainFailure.serverFailure(errorMessage: e.toString()));
    }
  }

  @override
  void clearExpenseList() {
    lastDocument = null;
    noMoreData = false;
  }

  @override
  Future<Either<MainFailure, Map<String, double>>>
      calculateTotalAmounts() async {
    try {
      final querySnapshot = await firestore.collection('expense').get();
      final expenseList = querySnapshot.docs.map(
        (exp) => ExpenseModel.fromMap(exp.data()),
      );

      double totalCredit = 0.0;
      double totalDebit = 0.0;

      for (var expense in expenseList) {
        if (expense.isAmountType) {
          totalCredit += expense.amount;
        } else {
          totalDebit += expense.amount;
        }
      }

      return right({
        'credit': totalCredit,
        'debit': totalDebit,
      });
    } catch (e) {
      return left(MainFailure.serverFailure(errorMessage: e.toString()));
    }
  }
}
