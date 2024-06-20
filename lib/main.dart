
//main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'library.dart';
import 'shelf_lib.dart';
import 'navigation.dart';
import 'sample_data.dart';
import 'database_helper.dart';
import 'profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  await insertSampleData();
  runApp(MyApp());
}

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            theme: ThemeData(
              primaryColor: Colors.green,
              textTheme: TextTheme(
                headlineLarge: TextStyle(color: Colors.black),
                headlineSmall: TextStyle(color: Colors.black),
              ),
              appBarTheme: AppBarTheme(
                titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: Colors.green,
              textTheme: TextTheme(
                headlineLarge: TextStyle(color: Colors.white),
                headlineSmall: TextStyle(color: Colors.white),
              ),
              appBarTheme: AppBarTheme(
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.black,
              ),
            ),
            themeMode: themeNotifier.themeMode,
            home: MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const PlantLibraryScreen(),
    const PlantShelfScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
