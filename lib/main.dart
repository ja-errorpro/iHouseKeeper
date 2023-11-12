import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'iHouseKeeper',
      home: MainScreen(),
    ); // MaterialApp
  } // build()
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('iHouseKeeper')),
      body: const Center(
        child: Text('Hello World'),
      ), // Center
    ); // Scaffold
  } // build()
}
