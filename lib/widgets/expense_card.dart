import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  final String description;
  final double value;
  final VoidCallback onDelete;

  const ExpenseCard({
    super.key,
    required this.description,
    required this.value,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(description),
        subtitle: Text(
          'R\$ ${value.toStringAsFixed(2)}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
