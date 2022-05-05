import 'dart:developer';

import 'package:chayxanhapp/bloc/datarestaurant_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CookProduct extends StatefulWidget {
  final String productID;
  final double value;
  const CookProduct({Key? key, required this.productID, required this.value})
      : super(key: key);

  @override
  _CookProductState createState() => _CookProductState();
}

class _CookProductState extends State<CookProduct> {
  DatarestaurantBloc datarestaurantBloc = DatarestaurantBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datarestaurantBloc = BlocProvider.of(context);
    datarestaurantBloc
        .add(DataCheckValue(productId: widget.productID, value: widget.value));
  }

  @override
  Widget build(BuildContext context) {
    showDialogResult(BuildContext context, String data) {
      AlertDialog alert = AlertDialog(
        content: Text(data),
        actions: [
          OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("cancel")),
          OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("ok"))
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    showLoaderDialog(BuildContext context, String data) {
      AlertDialog alert = AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            Container(margin: EdgeInsets.only(left: 7), child: Text(data)),
          ],
        ),
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    List data = [];
    bool canCook = true;
    double number = 0.0;
    List<DataRow> material = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cooking'),
      ),
      body: BlocBuilder(
          bloc: datarestaurantBloc,
          builder: (context, state) {
            if (state is DataResValue) {
              data = state.data;
              canCook = state.canCook;
              number = state.number;
              for (var i = 0; i < data.length; i++) {
                material.add(DataRow(cells: [
                  DataCell(Text(data[i]['Materials']['name'])),
                  DataCell(Text(data[i]['Materials']['total'].toString())),
                  DataCell(Text(data[i]['Materials']['valueRes'].toString())),
                  DataCell(Text(data[i]['Materials']['unit'])),
                ]));
              }
            }
            return Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      data.length != 0
                          ? Text(data[0]['Products']['name'])
                          : Text('waiting....')
                    ],
                  ),
                  Row(
                    children: [
                      number != 0
                          ? Text("Number product:" + number.toString())
                          : Text("waiting....")
                    ],
                  ),
                  data.length != 0
                      ? DataTable(
                          columns: const [
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text("Total")),
                            DataColumn(label: Text("Available")),
                            DataColumn(label: Text("Unit")),
                          ],
                          rows: material,
                        )
                      : Text('waiting....'),
                  data.length != 0
                      ? (canCook
                          ? OutlinedButton(
                              onPressed: () => {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text("Cook now ?"),
                                            actions: [
                                              OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("cancel")),
                                              BlocListener<DatarestaurantBloc,
                                                  DatarestaurantState>(
                                                bloc: datarestaurantBloc,
                                                listener: (context, state) {
                                                  if (state is DataUpdating) {
                                                    Navigator.pop(context);
                                                    showLoaderDialog(
                                                        context, "updating !");
                                                  } else if (state
                                                      is DataUpdated) {
                                                    Navigator.pop(context);
                                                    showDialogResult(
                                                        context, "updated");
                                                  } else if (state
                                                      is DataUpdateFail) {
                                                    Navigator.pop(context);
                                                    showDialogResult(
                                                        context, "fail");
                                                  }
                                                },
                                                child: OutlinedButton(
                                                    onPressed: () {
                                                      datarestaurantBloc.add(
                                                          DataUpdateValue(
                                                              data: data));
                                                    },
                                                    child: const Text("ok")),
                                              )
                                            ],
                                          );
                                        })
                                  },
                              child: const Text("Cook"))
                          : Text(""))
                      : Text('waiting....'),
                  data.length != 0
                      ? (canCook
                          ? Text('you can cook!')
                          : Text("you can't cook!"))
                      : Text('waiting....'),
                ],
              ),
            );
          }),
    );
  }
}
