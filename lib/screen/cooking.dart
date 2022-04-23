import 'package:chayxanhapp/bloc/datarestaurant_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CookingScreen extends StatefulWidget {
  const CookingScreen({Key? key}) : super(key: key);

  @override
  _CookingScreenState createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> {
  DatarestaurantBloc _datarestaurantBloc = DatarestaurantBloc();
  @override
  void initState() {
    // TODO: implement initState
    _datarestaurantBloc = BlocProvider.of(context);
    _datarestaurantBloc.add(DataCheck());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cooking")),
    );
  }
}
