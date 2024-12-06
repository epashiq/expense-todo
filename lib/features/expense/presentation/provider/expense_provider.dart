import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class ExpenseProvider with ChangeNotifier{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addExpenses()async{
    try {
      await firestore.collection('expense').doc().set({});

    } catch (e) {
      
    }
  }
}