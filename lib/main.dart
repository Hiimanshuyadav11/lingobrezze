import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/vocabulary_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LingoBreeze',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF3A9189),
          onPrimary: Colors.white,
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF1E3330),
        ),
        fontFamily: 'Roboto',
      ),
      home: const VocabularyPage(),
    );
  }
}