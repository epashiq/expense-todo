import 'package:expense_todo_app/features/expense/presentation/provider/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, expProvider, child) {
          if (expProvider.expenseList.isEmpty) {
            return const Center(
              child: Text('no expenses available'),
            );
          }
          return ListView.builder(
            itemCount: expProvider.expenseList.length,
            itemBuilder: (context, index) {
              final exp = expProvider.expenseList[index];
              return Card(
                child: ListTile(
                  title: Text(exp.title),
                  subtitle: Text(exp.amount.toString()),
                ),
              );
            },
          );
        },
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
                    // Title Input
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

                    // Amount Input
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
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),

                  // Add Button
                  ElevatedButton(
                    onPressed: () async {
                      await expenseProvider.addExpenses();
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
