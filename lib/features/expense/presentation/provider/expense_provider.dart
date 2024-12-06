import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_todo_app/features/expense/data/model/expense_model.dart';
import 'package:flutter/widgets.dart';

class ExpenseProvider with ChangeNotifier {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final scrollController = ScrollController;
  bool isAmountType = false;

  List<ExpenseModel> expenseList = [];
  DocumentSnapshot? lastDocument;
  bool isLoading = false;
  bool hasMoreData = true;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addExpenses() async {
    final amount = int.tryParse(amountController.text.trim());
    try {
      ExpenseModel expenseModel = ExpenseModel(
          title: titleController.text,
          amount: amount!,
          isAmountType: isAmountType);
      final userRef = firestore.collection('expense');
      final id = userRef.doc().id;
      final expense = expenseModel.copyWith(id: id);
      await firestore.collection('expense').doc(id).set(expense.toMap());
      log('expense added succesfully');
    } catch (e) {
      log(e.toString());
    }
  }

  void toggle(bool value) {
    isAmountType = value;
    notifyListeners();
  }

  Future<void> fetchExpenses() async {
    if (isLoading || !hasMoreData) return;
    isLoading = true;
    notifyListeners();
    log(isLoading.toString());

    try {
      Query query = firestore
          .collection('expense')
          .orderBy('title', descending: true)
          .limit(10);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.get();
      log('message');
      if (querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;
        final newList = querySnapshot.docs.map((exp)=> ExpenseModel.fromMap(exp.data() as Map<String,dynamic>));
         expenseList.addAll(newList);
        // for (var exp in querySnapshot.docs) {
        //   expenseList
        //       .add(ExpenseModel.fromMap((exp.data() as Map<String, dynamic>)));
        // }
        log(expenseList.length.toString());
      } else {
        hasMoreData = false;
        log('no expense available');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> initData({required ScrollController scrollController}) async {
    fetchExpenses();
    log('init');
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoading) {
            fetchExpenses();
        log('message');
      }
    });
  }

  void clearController(){
    titleController.clear();
    amountController.clear();
  }
}
