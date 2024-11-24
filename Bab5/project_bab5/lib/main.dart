import 'package:flutter/material.dart';
import 'package:flutter_application/screens/book_list.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Buku',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BooksListScreen(),
    );
  }
}