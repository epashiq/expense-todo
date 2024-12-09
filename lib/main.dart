import 'package:expense_todo_app/features/expense/data/iexpense_facade.dart';
import 'package:expense_todo_app/features/expense/presentation/provider/expense_provider.dart';
import 'package:expense_todo_app/features/expense/presentation/view/expense_page.dart';
import 'package:expense_todo_app/general/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependency();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                ExpenseProvider(iexpenseFacade: sl<IexpenseFacade>()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ExpensePage(),
      ),
    );
  }
}
