import 'package:flutter/material.dart';

void main() {
  runApp(const YugrowApp());
}

class YugrowApp extends StatelessWidget {
  const YugrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yugrow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const Scaffold(
        appBar: AppBar(title: Text('Yugrow Mobile')),
        body: Center(child: Text('Yugrow Mobile Running')),
      ),
    );
  }
}
