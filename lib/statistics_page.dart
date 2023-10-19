import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fl_chart/fl_chart.dart';
import 'database_helper.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  Database? _database = DatabaseHelper().database as Database?;
  List<Map<String, dynamic>> entries = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _loadEntries();
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'app_database.db'),
      version: 1,
      onCreate: (Database db, int version) {
        db.execute(
          'CREATE TABLE entries(id INTEGER PRIMARY KEY, odometerReading REAL, pricePerLiter REAL, totalCost REAL)',
        );
      },
    );
  }

  Future<void> _loadEntries() async {
    final List<Map<String, dynamic>> loadedEntries = await _database!.query('entries');
    setState(() {
      entries = loadedEntries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: entries.length < 2
          ? Center(
              child: Text('You need at least 2 entries to display statistics.'),
            )
          : Column(
              children: [
                AspectRatio(
                  aspectRatio: 1.70,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      minX: 0,
                      maxX: entries.length.toDouble() - 1,
                      minY: 0,
                      maxY: 50,
                      lineBarsData: [
                        LineChartBarData(
                          spots: _generateConsumptionData(),
                          isCurved: true,
                          colors: [Color.fromARGB(255, 139, 61, 170)],
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'Projected Kilometers: ${_calculateProjectedKilometers()} km',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
    );
  }

  List<FlSpot> _generateConsumptionData() {
    final List<FlSpot> spots = [];
    for (int i = 0; i < entries.length; i++) {
      final double consumption = entries[i]['odometerReading'] /
          (entries[i]['totalCost'] / entries[i]['pricePerLiter']);
      spots.add(FlSpot(i.toDouble(), consumption));
    }
    return spots;
  }

  double _calculateProjectedKilometers() {
    final lastEntry = entries.last;
    final liters = lastEntry['totalCost'] / lastEntry['pricePerLiter'];
    final consumption = lastEntry['odometerReading'] /
        (lastEntry['totalCost'] / lastEntry['pricePerLiter']);
    final projectedKilometers = (liters / consumption) * 100;
    return projectedKilometers;
  }
}
