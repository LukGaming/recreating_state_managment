import 'package:flutter/material.dart';
import 'package:utilizando_gerenciamendo_estado/presentation/pages/posts_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const PostsPage(),
    );
  }
}
