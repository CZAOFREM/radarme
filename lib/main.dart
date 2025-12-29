import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const MyApp()); // Launch app immediately without blocking

    // Initialize Firebase in background
    try {
      await Firebase.initializeApp();
      // Firebase initialized successfully
    } catch (e) {
      // Handle Firebase initialization error
      debugPrint('Firebase initialization failed: $e');
    }
  }, (error, stackTrace) {
    // Global error handling
    debugPrint('Global error: $error');
    debugPrint('Stack trace: $stackTrace');
  });
}