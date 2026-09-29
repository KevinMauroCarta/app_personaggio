import 'package:flutter/material.dart';

import 'screens/home/home_page.dart';

void main() {
  runApp(const AppPersonaggi());
}

class AppPersonaggi extends StatelessWidget {
  const AppPersonaggi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creazione Personaggi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
