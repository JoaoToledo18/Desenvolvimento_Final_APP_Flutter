import 'package:flutter/material.dart';

import '../repositories/expense_repository.dart';
import '../models/expense.dart';
import '../widgets/expense_card.dart';
import '../widgets/total_card.dart';
import 'add_expense_page.dart';
import 'summary_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {
  final repository =
      ExpenseRepository();

  List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    final data =
        await repository.getAll();

    setState(() {
      expenses = data;
    });
  }

  double get total {
    return expenses.fold(
      0,
      (sum, item) =>
          sum + item.value,
    );
  }

  Future<void> deleteExpense(
      int id) async {
    await repository.delete(id);
    loadExpenses();
  }

  Future<void> navigateToAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const AddExpenseScreen(),
      ),
    );

    loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Controle de Gastos',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SummaryScreen(
                    total: total,
                    expenses: expenses,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.bar_chart,
            ),
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [
            TotalCard(total: total),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child:
                  ListView.builder(
                itemCount:
                    expenses.length,
                itemBuilder:
                    (context, index) {
                  final expense =
                      expenses[index];

                  return ExpenseCard(
                    description:
                        expense
                            .description,
                    value:
                        expense.value,
                    onDelete: () =>
                        deleteExpense(
                      expense.id!,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: navigateToAdd,
        child:
            const Icon(Icons.add),
      ),
    );
  }
}
