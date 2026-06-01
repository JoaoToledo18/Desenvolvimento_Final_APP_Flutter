import '../models/expense.dart';
import '../services/database_service.dart';

class ExpenseRepository {
  Future<void> insert(Expense expense) async {
    final db = await DatabaseService.instance.database;

    await db.insert(
      'expenses',
      expense.toMap(),
    );
  }

  Future<List<Expense>> getAll() async {
    final db = await DatabaseService.instance.database;

    final result = await db.query('expenses');

    return result
        .map((e) => Expense.fromMap(e))
        .toList();
  }

  Future<void> delete(int id) async {
    final db = await DatabaseService.instance.database;

    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
