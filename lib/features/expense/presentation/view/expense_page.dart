import 'dart:developer';

import 'package:expense_todo_app/features/expense/presentation/provider/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      expenseProvider.fetchExpenses();
      expenseProvider.calculateExpenses();
      log('init');
      // scrollController.addListener(() {
      //   if (scrollController.position.pixels ==
      //           scrollController.position.maxScrollExtent &&
      //       !expenseProvider.isLoading &&
      //       !expenseProvider.noMoreData) {
      //     expenseProvider.fetchExpenses();
      //   }
      // });
      expenseProvider.initData(scrollController: scrollController);
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.arrow_circle_up,
                      size: 40, color: Colors.white),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Total Credit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: expenseProvider.totalCredit,
                          end: expenseProvider.totalCredit,
                        ),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) {
                          return Text(
                            '\$${value.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Animated Debit Card
          Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade400, Colors.red.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.arrow_circle_down,
                      size: 40, color: Colors.white),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Total Debit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: expenseProvider.totalDebit,
                          end: expenseProvider.totalDebit,
                        ),
                        duration: const Duration(seconds: 2),
                        builder: (context, value, child) {
                          return Text(
                            '\$${value.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, expProvider, child) {
                if (expProvider.isLoading && expProvider.expenseList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (expProvider.expenseList.isEmpty) {
                  return const Center(child: Text('No expenses available'));
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount: expProvider.expenseList.length,
                  itemBuilder: (context, index) {
                    final exp = expProvider.expenseList[index];
                    return Card(
                      child: ListTile(
                        title: Text(exp.title),
                        subtitle: Text(exp.amount.toString()),
                        trailing: Text(exp.isAmountType ? 'Credit' : 'Debit'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Expense"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: expenseProvider.titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: expenseProvider.amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: Text(
                          expenseProvider.isAmountType ? "Credit" : "Debit"),
                      value: expenseProvider.isAmountType,
                      onChanged: (value) {
                        expenseProvider.toggle(value);
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      expenseProvider.clearController();
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      await expenseProvider.addExpenses();
                      expenseProvider.clearController();
                      Navigator.pop(context);
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
