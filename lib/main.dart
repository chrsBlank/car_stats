import 'package:flutter/material.dart';
import 'main_page.dart'; // Import the main page
import 'statistics_page.dart'; // Import the statistics page
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _pages = [MainPage(), StatisticsPage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.add), // Icon for the "Capture Entry" page
              label: 'Capture Entry',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), // Icon for the "Statistics" page
              label: 'Statistics',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
