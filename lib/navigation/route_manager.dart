import 'package:flutter/material.dart';

import '../app.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/home/home_container.dart';
import '../features/intro_video_screen.dart';
import '../features/onboarding_flow.dart';

// Placeholder pages
class RADARTVPage extends StatelessWidget {
  const RADARTVPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('RADARTV Page')));
  }
}

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Music Page')));
  }
}

class MagazinePage extends StatelessWidget {
  const MagazinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Magazine Page')));
  }
}

class RADARRoomPage extends StatelessWidget {
  const RADARRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('RADARRoom Page')));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Profile Page')));
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Page Not Found')));
  }
}

class RouteManager {
  // Named routes
  static const String intro = '/intro';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String shell = '/shell';
  static const String radartv = '/radartv';
  static const String music = '/music';
  static const String magazine = '/magazine';
  static const String radarroom = '/radarroom';
  static const String profile = '/profile';

  // Generate route with guards and fallback
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case intro:
        return _guardedRoute(const IntroVideoScreen(), settings);
      case onboarding:
        return _guardedRoute(const OnboardingFlow(), settings);
      case login:
        return _guardedRoute(const LoginScreen(), settings);
      case register:
        return _guardedRoute(const RegisterScreen(), settings);
      case home:
        return _guardedRoute(const HomeContainer(), settings);
      case shell:
        return _guardedRoute(const AppScaffold(), settings);
      case radartv:
        return _guardedRoute(const RADARTVPage(), settings);
      case music:
        return _guardedRoute(const MusicPage(), settings);
      case magazine:
        return _guardedRoute(const MagazinePage(), settings);
      case radarroom:
        return _guardedRoute(const RADARRoomPage(), settings);
      case profile:
        return _guardedRoute(const ProfilePage(), settings);
      default:
        return _fallbackRoute(settings);
    }
  }

  // Role-aware guard (placeholder)
  static Route<dynamic> _guardedRoute(Widget page, RouteSettings settings) {
    if (_checkRole()) {
      return MaterialPageRoute(builder: (_) => page, settings: settings);
    } else {
      return _fallbackRoute(settings);
    }
  }

  // Graceful fallback
  static Route<dynamic> _fallbackRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const NotFoundPage(),
      settings: settings,
    );
  }

  // Placeholder role check
  static bool _checkRole() {
    // TODO: Implement actual role checking
    return true; // Allow all for now
  }
}