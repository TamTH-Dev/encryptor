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
        primaryColor: const Color(0xFF38A3A5),
      ),
      home: const Encryptor(),
    );
  }
}
