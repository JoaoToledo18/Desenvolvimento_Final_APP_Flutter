class Expense {
  final int? id;
  final String description;
  final double value;
  final String date;
  final String category;

  Expense({
    this.id,
    required this.description,
    required this.value,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'value': value,
      'date': date,
      'category': category,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      description: map['description'],
      value: map['value'],
      date: map['date'],
      category: map['category'] ?? 'Outros',
    );
  }
}
