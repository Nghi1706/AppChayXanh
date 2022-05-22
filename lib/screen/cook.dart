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

    showDialogResult(BuildContext context, String data) {
      AlertDialog alert = AlertDialog(
        content: Text(data),
        actions: [
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

    List data = [];
    bool canCook = true;
    double number = 0.0;
    List<DataRow> material = [];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cooking'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    log("ok");
                    datarestaurantBloc.add(DataCheckValue(
                        productId: widget.productID, value: widget.value));
                  });
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Column(
              children: [
                BlocListener<DatarestaurantBloc, DatarestaurantState>(
                    bloc: datarestaurantBloc,
                    listener: (context, state) {
                      if (state is DataUpdating) {
                        Navigator.pop(context);
                        showLoaderDialog(context, "updating !");
                      }
                      if (state is DataUpdated) {
                        Navigator.pop(context);
                        showDialogResult(context, "updated");
                      }
                      if (state is DataUpdateFail) {
                        Navigator.pop(context);
                        showDialogResult(context, "fail");
                      }
                    },
                    child: Container()),
                BlocBuilder(
                    bloc: datarestaurantBloc,
                    builder: (context, state) {
                      if (state is DataResValue) {
                        data = state.data;
                        canCook = state.canCook;
                        number = state.number;
                        for (var i = 0; i < data.length; i++) {
                          material.add(DataRow(cells: [
                            DataCell(Text(data[i]['Materials']['name'])),
                            DataCell(Text(data[i]['Materials']['total']
                                .toStringAsFixed(2))),
                            DataCell(Text(data[i]['Materials']['valueRes']
                                .toStringAsFixed(2))),
                            DataCell(Text(data[i]['Materials']['unit'])),
                          ]));
                        }
                      }
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                data.length != 0
                                    ? Text(
                                        "Name : " + data[0]['Products']['name'],
                                        style: TextStyle(fontSize: 20),
                                      )
                                    : Text('waiting....')
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                number != 0
                                    ? Text(
                                        "Number product : " + number.toString(),
                                        style: TextStyle(fontSize: 20))
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
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content:
                                                          Text("Cook now ?"),
                                                      actions: [
                                                        OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "cancel")),
                                                        OutlinedButton(
                                                            onPressed: () {
                                                              datarestaurantBloc.add(
                                                                  DataUpdateValue(
                                                                      data:
                                                                          data));
                                                            },
                                                            child: const Text(
                                                                "ok"))
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
                    })
              ],
            ))));
  }
}
