import 'package:flutter/material.dart';
import 'package:cdr_iesc/screens/home.dart';
import 'package:cdr_iesc/screens/comparation_loader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const Home(
          title:
            'Select an input file, generate the output file and '
            'select the columns to compare',
        ),
        '/compare': (context) => const Loader(title: 'Comparision Loader'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Home(title: widget.title);
  }
}
