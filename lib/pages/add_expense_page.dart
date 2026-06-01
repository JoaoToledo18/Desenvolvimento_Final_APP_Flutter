import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../repositories/expense_repository.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final repository = ExpenseRepository();
  final descriptionController = TextEditingController();
  final valueController = TextEditingController();

  final List<String> categories = [
    'Alimentação',
    'Transporte',
    'Saúde',
    'Lazer',
    'Educação',
    'Outros',
  ];
  String selectedCategory = 'Outros';

  Future<void> save() async {
    final description = descriptionController.text;
    final value =
        double.tryParse(valueController.text) ?? 0;
    final date = DateTime.now().toIso8601String();

    await repository.insert(
      Expense(
        description: description,
        value: value,
        date: date,
        category: selectedCategory,
      ),
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Gasto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
              ),
            ),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'Valor',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Categoria',
              ),
              items: categories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(
                    () => selectedCategory = value,
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: save,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
