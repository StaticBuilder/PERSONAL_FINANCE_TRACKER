import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:finance_tracker_app/screens/add_expense/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:finance_tracker_app/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:finance_tracker_app/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:finance_tracker_app/screens/stats/budget_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import '../../add_expense/views/add_expense.dart';
import '../../stats/stats.dart';
import 'main_screen.dart';
//import 'budget_screen.dart'; // Make sure to import the new budget screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  late Color selectedItem = Colors.blue;
  Color unselectedItem = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
      builder: (context, state) {
        if (state is GetExpensesSuccess) {
          return Scaffold(
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0), // Adjust the padding to lower the BottomNavigationBar
                child: BottomNavigationBar(
                  onTap: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  elevation: 3,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.home, color: index == 0 ? selectedItem : unselectedItem),
                        label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.graph_square_fill, color: index == 1 ? selectedItem : unselectedItem),
                        label: 'Stats'),
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.money_dollar_circle, color: index == 2 ? selectedItem : unselectedItem),
                        label: 'Budget'),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 16.0), // Adjust the padding to raise the floating action button
              child: FloatingActionButton(
                onPressed: () async {
                  Expense? newExpense = await Navigator.push(
                    context,
                    MaterialPageRoute<Expense>(
                      builder: (BuildContext context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => CreateCategoryBloc(FirebaseExpenseRepo()),
                          ),
                          BlocProvider(
                            create: (context) => GetCategoriesBloc(FirebaseExpenseRepo())..add(GetCategories()),
                          ),
                          BlocProvider(
                            create: (context) => CreateExpenseBloc(FirebaseExpenseRepo()),
                          ),
                        ],
                        child: const AddExpense(),
                      ),
                    ),
                  );

                  if (newExpense != null) {
                    setState(() {
                      state.expenses.insert(0, newExpense);
                    });
                  }
                },
                shape: const CircleBorder(),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.tertiary,
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.primary,
                        ],
                        transform: const GradientRotation(pi / 4),
                      )),
                  child: const Icon(CupertinoIcons.add),
                ),
              ),
            ),
            body: index == 0
                ? MainScreen(state.expenses)
                : index == 1
                    ? const StatScreen()
                    : const BudgetScreen(),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}