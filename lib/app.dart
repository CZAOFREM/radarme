import 'package:flutter/material.dart';

import 'core/theme/animations.dart';
import 'core/theme/colors.dart';
import 'core/theme/typography.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RADARMe',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryBlack,
        scaffoldBackgroundColor: primaryBlack,
        appBarTheme: const AppBarTheme(
          backgroundColor: softBlack,
          foregroundColor: primaryWhite,
        ),
        textTheme: const TextTheme(
          displayLarge: titleStyle,
          bodyLarge: bodyStyle,
          bodyMedium: metaStyle,
          labelLarge: buttonStyle,
        ),
        colorScheme: const ColorScheme.dark(
          primary: primaryBlack,
          secondary: neutralGrey,
          surface: softBlack,
          background: primaryBlack,
          onPrimary: primaryWhite,
          onSecondary: primaryWhite,
          onSurface: primaryWhite,
          onBackground: primaryWhite,
        ),
        dividerColor: dividerGrey,
        useMaterial3: true,
      ),
      home: const AppScaffold(),
    );
  }
}

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home Placeholder')),
    Center(child: Text('Search Placeholder')),
    Center(child: Text('Profile Placeholder')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}