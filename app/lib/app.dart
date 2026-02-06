import 'package:flutter/material.dart';
import 'package:skeleton_app/screens/home_screen.dart';
// --- OPTIONAL: deep_linking ---
import 'package:skeleton_app/features/deep_linking.dart';
// --- END: deep_linking ---

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // --- OPTIONAL: deep_linking ---
  final DeepLinkingHandler _deepLinking = DeepLinkingHandler();

  @override
  void initState() {
    super.initState();
    _deepLinking.initialize();
  }

  @override
  void dispose() {
    _deepLinking.dispose();
    super.dispose();
  }
  // --- END: deep_linking ---

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skeleton App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
