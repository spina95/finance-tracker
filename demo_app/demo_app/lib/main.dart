import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("test"),
          centerTitle: true,
        ),
        body: ListView(
          shrinkWrap: true,
          children: const [
            Text('Hello, World!'),
            SizedBox(height: 16),
            Text('This is a simple Flutter app.'),
            SizedBox(height: 16),
            Text('Tap anywhere to add a new item.'),
          ],
        ),
      ),
    );
  }
}
