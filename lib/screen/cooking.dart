import 'dart:developer';

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

  checkColor(String number) {
    int numberColor = int.parse(number);
    log(number);
    if (numberColor == 0) {
      return Colors.yellow[200];
    } else if (numberColor == -1) {
      return Colors.red[200];
    } else if (numberColor == 1) {
      return Colors.green[200];
    } else if (numberColor == 2) {
      return Colors.blue[200];
    }
  }

  @override
  Widget build(BuildContext context) {
    List product = [];
    return Scaffold(
      appBar: AppBar(title: const Text("Cooking")),
      body: BlocBuilder<DatarestaurantBloc, DatarestaurantState>(
        bloc: _datarestaurantBloc,
        builder: (context, state) {
          if (state is DataRes) {
            product = state.data;
          }
          return ListView.builder(
              itemCount: product.length,
              itemBuilder: (context, index) {
                return InkWell(
                  child: Card(
                    color: checkColor(product[index]['status'].toString()),
                    child: ListTile(
                      title: Text(product[index]['name']),
                      subtitle: Text(product[index]['cost'].toString()),
                      trailing: Text("available :" +
                          product[index]['available'].toString()),
                    ),
                  ),
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute<void>(
                  //       builder: (BuildContext context) => BlocProvider(
                  //         create: (context) => ProductBloc(),
                  //         child: ProductInfo(
                  //           idProduct: product[index]['_id'],
                  //           role: role,
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // },
                );
              });
        },
      ),
    );
  }
}
