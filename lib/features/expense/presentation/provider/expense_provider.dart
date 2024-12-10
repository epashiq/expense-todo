import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_todo_app/features/expense/data/iexpense_facade.dart';
import 'package:expense_todo_app/features/expense/data/model/expense_model.dart';
import 'package:flutter/widgets.dart';

class ExpenseProvider with ChangeNotifier {
  final IexpenseFacade iexpenseFacade;
  ExpenseProvider({required this.iexpenseFacade});

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final scrollController = ScrollController;
  bool isAmountType = false;

  double totalCredit = 0.0;
    double totalDebit = 0.0;

  List<ExpenseModel> expenseList = [];
  // DocumentSnapshot? lastDocument;
  bool isLoading = false;
  // bool noMoreData = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addExpenses() async {
    final amount = int.tryParse(amountController.text.trim());
    final result = await iexpenseFacade.addExpenses(
        expenseModel: ExpenseModel(
            title: titleController.text,
            amount: amount!,
            isAmountType: isAmountType));
    result.fold(
      (error) async {
        log(error.toString());
      },
      (success) {
        log(success.toString());
        addLocally(success);
      },
    );

    // try {
    //   ExpenseModel expenseModel = ExpenseModel(
    //       title: titleController.text,
    //       amount: amount!,
    //       isAmountType: isAmountType);
    //   final userRef = firestore.collection('expense');
    //   final id = userRef.doc().id;
    //   final expense = expenseModel.copyWith(id: id);
    //   await firestore.collection('expense').doc(id).set(expense.toMap());
    //   log('expense added succesfully');
    //   addLocally(expense);
    // } catch (e) {
    //   log(e.toString());
    // }
  }

  void toggle(bool value) {
    isAmountType = value;
    notifyListeners();
  }

  // Future<void> fetchExpenses() async {
  //   if (isLoading || noMoreData) return;
  //   isLoading = true;
  //   notifyListeners();
  //   log(isLoading.toString());

  //   try {
  //     Query query =
  //         firestore.collection('expense').orderBy('title', descending: false);

  //     if (lastDocument != null) {
  //       query = query.startAfterDocument(lastDocument!);
  //     }

  //     QuerySnapshot querySnapshot = await query.limit(10).get();
  //     log('message');
  //     if (querySnapshot.docs.isNotEmpty) {
  //       lastDocument = querySnapshot.docs.last;
  //       final newList = querySnapshot.docs.map(
  //           (exp) => ExpenseModel.fromMap(exp.data() as Map<String, dynamic>));
  //       expenseList.addAll(newList);
  //       // for (var exp in querySnapshot.docs) {
  //       //   expenseList
  //       //       .add(ExpenseModel.fromMap((exp.data() as Map<String, dynamic>)));
  //       // }
  //       log(expenseList.length.toString());
  //     } else {
  //       noMoreData = true;
  //       log('no more data: ${noMoreData.toString()}');
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

Future<void> fetchExpenses()async{
  isLoading = true;
  notifyListeners();
  final result = await iexpenseFacade.fetchExpenses();

  result.fold((failure) {
    log(failure.errorMessage);
  }, (success) {
    expenseList.addAll(success);

  },);
  isLoading = false;
  notifyListeners();
}

  Future<void> calculateExpenses() async {
    
    final result = await iexpenseFacade.calculateTotalAmounts();

    result.fold(
      (failure) {
        log(failure.errorMessage);
      },
      (success)async {
        totalCredit = success['credit'] ?? 0.0;
        totalDebit = success['debit'] ?? 0.0;
        await calculateExpenses();
        notifyListeners();
      },
    );
  }

  Future<void> initData({required ScrollController scrollController}) async {
    clearExpenseList();
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

  void clearController() {
    titleController.clear();
    amountController.clear();
  }

  void addLocally(ExpenseModel expense) {
    expenseList.insert(0, expense);
  }

  void clearExpenseList() {
    iexpenseFacade.clearExpenseList();
    expenseList = [];
    notifyListeners();
  }
}
