import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'smart_spend.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');
  }

  // Insert a new transaction.
  Future<void> insertTransaction(Transaction tx) async {
    final db = await database;
    await db.insert(
      'transactions',
      tx.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all transactions, most recent first.
  Future<List<Transaction>> getTransactions() async {
    final db = await database;
    final result = await db.query('transactions', orderBy: 'date DESC');
    return result.map((row) => Transaction.fromMap(row)).toList();
  }

  // Delete a single transaction by id.
  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // Delete all transactions ("Clear All").
  Future<void> clearTransactions() async {
    final db = await database;
    await db.delete('transactions');
  }
}
