import 'package:flutter/material.dart';

import 'encryptor.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encryptor',
      theme: ThemeData(
        primaryColor: const Color(0xFF475CFA),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF475CFA), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF6173FF), width: 1.5),
          ),
        ),
      ),
      home: const Encryptor(),
    );
  }
}
