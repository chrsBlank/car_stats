import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE entries(id INTEGER PRIMARY KEY, odometerReading REAL, pricePerLiter REAL, totalCost REAL)',
        );
      },
    );
  }

  Future<void> insertEntry(double odometerReading, double pricePerLiter, double totalCost) async {
    final db = await database;
    await db.insert(
      'entries',
      {
        'odometerReading': odometerReading,
        'pricePerLiter': pricePerLiter,
        'totalCost': totalCost,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>?> getEntries() async {
    final db = await database;
    return db.query('entries');
  }
}
