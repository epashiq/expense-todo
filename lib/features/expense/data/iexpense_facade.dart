import 'package:expense_todo_app/features/expense/data/model/expense_model.dart';
import 'package:expense_todo_app/general/failure/failures.dart';
import 'package:dartz/dartz.dart';

abstract class IexpenseFacade {
  Future<Either<MainFailure,ExpenseModel>> addExpenses({required ExpenseModel expenseModel}){
    throw UnimplementedError('error');
  }
  Future<Either<MainFailure,List<ExpenseModel>>> fetchExpenses()async{
    throw UnimplementedError('error');
  }

  void clearExpenseList();
}