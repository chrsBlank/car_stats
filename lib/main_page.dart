import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_helper.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Database? _database = DatabaseHelper().database as Database?;
  TextEditingController odometerController = TextEditingController();
  TextEditingController pricePerLiterController = TextEditingController();
  TextEditingController totalCostController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'app_database.db'),
      version: 1,
      onCreate: (Database db, int version) {
        // Create the table to store user entries.
        db.execute(
          'CREATE TABLE entries(id INTEGER PRIMARY KEY, odometerReading REAL, pricePerLiter REAL, totalCost REAL)',
        );
      },
    );
  }

  Future<void> _insertEntry(double odometerReading, double pricePerLiter, double totalCost) async {
    await _database!.insert(
      'entries',
      {
        'odometerReading': odometerReading,
        'pricePerLiter': pricePerLiter,
        'totalCost': totalCost,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Values'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: odometerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Odometer Reading (in km)'),
            ),
            TextField(
              controller: pricePerLiterController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price Per Liter'),
            ),
            TextField(
              controller: totalCostController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Total Cost'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Get user inputs and perform calculations here.
                double odometerReading = double.parse(odometerController.text);
                double pricePerLiter = double.parse(pricePerLiterController.text);
                double totalCost = double.parse(totalCostController.text);

                // Store the entry in the local database.
                _insertEntry(odometerReading, pricePerLiter, totalCost);

                // Perform calculations and projections.
                double kilometersDriven = odometerReading;
                double averageConsumption = kilometersDriven / (totalCost / pricePerLiter);

                // Add code to display or store the results.

                // Clear the input fields.
                odometerController.clear();
                pricePerLiterController.clear();
                totalCostController.clear();
              },
              child: Text('Calculate and Store Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
