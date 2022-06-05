import 'dart:developer';
import 'package:chayxanhapp/bloc/material_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Tranfer extends StatefulWidget {
  final data;
  const Tranfer({Key? key, required this.data}) : super(key: key);

  @override
  _TranferState createState() => _TranferState();
}

class DataTransfer {
  final String id;
  final Materials;
  final Restaurants;
  final available_old;
  final available_new;
  final isDeleted;
  final v;
  const DataTransfer(
      {required this.id,
      this.Materials,
      required this.Restaurants,
      required this.available_new,
      required this.available_old,
      required this.isDeleted,
      required this.v});
}

class _TranferState extends State<Tranfer> {
  MaterialBloc materialBloc = MaterialBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    materialBloc
        .add(FetchRestaurant(materialId: widget.data['Materials']['_id']));
    log(widget.data.toString());
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

    final _idFrom = widget.data['_id'];
    var availableOldFrom = widget.data['available_new'];
    var availableNewFrom = 0.0;
    var _idTo;
    var availableOldTo = 0.0;
    var availableNewTo = 0.0;
    var tranferNumber = 0.0;
    List listRestaurant = [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
        centerTitle: true,
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocListener(
                  bloc: materialBloc,
                  listener: (context, state) {
                    if (state is Fetching) {
                      showLoaderDialog(context, 'waiting !');
                    }
                    if (state is ListData) {
                      Navigator.pop(context);
                    }
                    if (state is Fetched) {
                      Navigator.pop(context);
                      showDialogResult(context, 'success !');
                    }
                    if (state is Fail) {
                      Navigator.pop(context);
                      showDialogResult(context, 'fail !');
                    }
                  },
                  child: Container(),
                ),
                Text(
                  widget.data['Materials']['name'] +
                      '-' +
                      widget.data['available_new'].toString() +
                      widget.data['Materials']['unit'],
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Number Transfer'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) => {
                    tranferNumber = double.parse(value),
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Choose Restaurant', style: TextStyle(fontSize: 20)),
                SizedBox(
                  height: 10,
                ),
                BlocBuilder(
                    bloc: materialBloc,
                    builder: (context, state) {
                      if (state is ListData) {
                        listRestaurant = state.data;
                      }
                      return DropdownButtonFormField(
                        items: listRestaurant.map((restaurant) {
                          return DropdownMenuItem<String>(
                            value: restaurant['_id'],
                            child: Text(
                              restaurant['Restaurants']['name'] +
                                  restaurant['available_new'].toString() +
                                  restaurant['Materials']['unit'],
                              style: const TextStyle(color: Colors.green),
                            ),
                            onTap: () {
                              _idTo = restaurant['_id'].toString();
                              availableOldTo =
                                  restaurant['available_new'] / 1.0;
                            },
                          );
                        }).toList(),
                        onChanged: (value) {
                          log(_idTo);
                          log(availableOldTo.toString());
                        },
                      );
                    }),
                OutlinedButton(
                    onPressed: () {
                      if (_idFrom == _idTo) {
                        showDialogResult(
                            context, "Can't transfer, conflict restaurant");
                      } else if (availableOldFrom / 1.0 - tranferNumber / 1.0 <
                          0.0) {
                        showDialogResult(context, "Can't transfer, not enough");
                      } else {
                        var dataDes = {
                          "id": _idFrom,
                          "available_old": availableOldFrom.toString(),
                          "available_new":
                              (availableOldFrom / 1.0 - tranferNumber / 1.0)
                                  .toString()
                        };
                        var dataIns = {
                          "id": _idTo,
                          "available_old": availableOldTo.toString(),
                          "available_new":
                              (availableOldTo / 1.0 + tranferNumber / 1.0)
                                  .toString()
                        };
                        materialBloc.add(RestaurantMaterialTransfer(
                            dataOld: dataDes, dataNew: dataIns));
                      }
                    },
                    child: const Text("Trans"))
              ],
            ),
          )),
    );
  }
}
