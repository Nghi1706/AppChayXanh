import 'dart:developer';

import 'package:chayxanhapp/bloc/datarestaurant_bloc.dart';
import 'package:chayxanhapp/screen/cook.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CookingScreen extends StatefulWidget {
  const CookingScreen({Key? key}) : super(key: key);

  @override
  _CookingScreenState createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> {
  DatarestaurantBloc _datarestaurantBloc = DatarestaurantBloc();
  double number = 0.0;
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
      appBar: AppBar(
        title: const Text("Cooking"),
      ),
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
                    color: checkColor(
                        product[index]['Products']['status'].toString()),
                    child: ListTile(
                      title: Text(product[index]['Products']['name']),
                      subtitle:
                          Text(product[index]['Products']['cost'].toString()),
                      trailing: const Text("tap to cooking"),
                    ),
                  ),
                  onTap: () {
                    product[index]['Products']['status'] == 2
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                title: Text('Nhập số lượng'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextField(
                                        decoration: new InputDecoration(
                                            labelText: "update available"),
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .singleLineFormatter
                                        ],
                                        onChanged: (value) => {
                                          number = double.parse(value),
                                        }, // Only numbers can be entered
                                      )
                                    ],
                                  ),
                                ),
                                actionsOverflowButtonSpacing: 20,
                                actions: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color.fromARGB(255, 248, 54, 40)),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)))),
                                    ),
                                    child: const Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              BlocProvider(
                                            create: (context) =>
                                                DatarestaurantBloc(),
                                            child: CookProduct(
                                              productID: product[index]
                                                  ['Products']['_id'],
                                              value: number,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)))),
                                    ),
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          )
                        : showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                content: const Text(
                                    "The product has not been accepted by Host"),
                                actionsOverflowButtonSpacing: 20,
                                actions: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)))),
                                    ),
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                  },
                );
              });
        },
      ),
    );
  }
}
