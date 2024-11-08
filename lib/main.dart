import 'package:energy_app/pages/home_page.dart';
import 'package:energy_app/pages/login_page.dart';
import 'package:energy_app/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      color: Color.fromRGBO(114, 187, 57, 1),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: TelaInicial(),
      // home: LoginPage(),
    );
  }
}
