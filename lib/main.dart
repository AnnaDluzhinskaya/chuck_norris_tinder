import 'package:chuck_norris_tinder/services/network_service.dart';
import 'package:chuck_norris_tinder/widget/card_stack_widget.dart';
import 'package:chuck_norris_tinder/model/user.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor: Colors.white,
            minimumSize: const Size(120, 60),
            maximumSize: const Size(200, 80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            )
          )
        )
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<User> jokeCards = <User>[];



  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white, Colors.orangeAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.5, 1]
      )
    ),
    child: const Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CardsStackWidget(),
      ),
    ),
  );
}
