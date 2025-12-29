import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/animations.dart';
import 'core/theme/colors.dart';
import 'core/theme/typography.dart';
import 'features/auth/login_screen.dart';
import 'features/intro_video_screen.dart';
import 'features/onboarding_flow.dart';
import 'navigation/route_manager.dart';

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
      home: const AppShell(),
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late Future<Map<String, bool>> _prefsFuture;

  @override
  void initState() {
    super.initState();
    _prefsFuture = _loadPrefs();
  }

  Future<Map<String, bool>> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'introPlayed': prefs.getBool('introPlayed') ?? false,
      'onboarded': prefs.getBool('onboarded') ?? false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, bool>>(
      future: _prefsFuture,
      builder: (context, prefsSnapshot) {
        if (prefsSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final prefs = prefsSnapshot.data!;
        final introPlayed = prefs['introPlayed']!;
        final onboarded = prefs['onboarded']!;

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Colors.black,
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final user = authSnapshot.data;

            if (user == null) {
              if (!introPlayed) {
                return const IntroVideoScreen();
              } else if (!onboarded) {
                return const OnboardingFlow();
              } else {
                return const LoginScreen();
              }
            } else {
              return const AppScaffold();
            }
          },
        );
      },
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
    Center(child: Text('RADARTV Placeholder')),
    Center(child: Text('Music Placeholder')),
    Center(child: Text('Magazine Placeholder')),
    Center(child: Text('RADARRoom Placeholder')),
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
            icon: Icon(Icons.tv),
            label: 'RADARTV',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Music',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Magazine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'RADARRoom',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}