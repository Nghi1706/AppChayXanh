import 'dart:convert';
import 'dart:developer';

import 'package:chayxanhapp/bloc/menu_bloc.dart';
import 'package:chayxanhapp/screen/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String loginMessage = '';
  String _phoneNumber = '';
  String _password = '';
  LoginBloc loginBloc = LoginBloc();
  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                    child: Image.asset(
                  'img/chayxanh.png',
                  width: 200,
                )),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Phone number'),
                  onChanged: (value) => {
                    _phoneNumber = value,
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Password'),
                  onChanged: (value) => {
                    _password = value,
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocListener<LoginBloc, LoginState>(
                  bloc: loginBloc,
                  listener: (context, state) {
                    if (state is LoginStatus) {
                      if (state.status) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => BlocProvider(
                              create: (context) => MenuBloc(),
                              child: Menu(),
                            ),
                          ),
                        );
                      }
                      loginMessage = state.message;
                    }
                  },
                  child: OutlinedButton(
                      onPressed: () => {
                            loginBloc.add(LoginEvent(
                                phoneNumber: _phoneNumber,
                                passWord: _password)),
                          },
                      child: const Text("Login")),
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return Text(loginMessage);
                  },
                )
              ],
            ),
          )),
    );
  }
}
