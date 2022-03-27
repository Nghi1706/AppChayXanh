import 'package:chayxanhapp/bloc/login_bloc.dart';
import 'package:chayxanhapp/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "login screen",
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: const Color(0xFF4CAF50)),
        ),
        home: BlocProvider(
          create: (context) => LoginBloc(),
          child: const LoginScreen(),
        ));
  }
}
