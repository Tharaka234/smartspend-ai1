class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category; // e.g., 'Food', 'Transport', 'Entertainment'

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  // Convert a Transaction into a Map for sqflite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  // Build a Transaction from a database row.
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      category: map['category'] as String,
    );
  }
}
