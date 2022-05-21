import 'dart:developer';

import 'package:chayxanhapp/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProducts extends StatefulWidget {
  List material = [];
  int role;
  AddProducts({Key? key, required this.material, required this.role})
      : super(key: key);

  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  ProductBloc productBloc = ProductBloc();
  List<Widget> _selection = [];
  final List _value = ["1item", "2item", "10g", "20g", "50g", "100g"];
  List productMaterial = [];
  String name = '';
  String cost = '0';
  int i = 0;

  // var params = {"value"+ i.toString(): "", "name": ""};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productBloc = BlocProvider.of(context);
  }

  void _addSelection() {
    if (i < 5) {
      setState(() {
        productMaterial.add({});
        i += 1;
      });
    }
  }

  void _deleteSelection() {
    if (i > 1) {
      setState(() {
        productMaterial.removeLast();
        i -= 1;
      });
    }
  }

  checkProductMaterial() async {
    if (productMaterial.length == 0) {
      return false;
    } else
      return true;
    // try {
    //   for (var l = 0; l < productMaterial.length; i++) {
    //     productMaterial[l]['value'];
    //     for (var k = l + 1; k < productMaterial.length; k++) {
    //       if (productMaterial[l]['name'] == productMaterial[k]['name']) {
    //         return false;
    //       }
    //     }
    //   }
    //   return true;
    // } catch (error) {
    //   return false;
    // }
  }

  _dataSelection(value) {
    switch (value) {
      case "1item":
        return 1;
      case "2item":
        return 2;
      case "10g":
        return 0.01;
      case "20g":
        return 0.02;
      case "50g":
        return 0.05;
      case "100g":
        return 0.1;
    }
  }

  Widget _selectMaterial() {
    List material = widget.material;
    return productMaterial.length > 0
        ? Column(
            children: productMaterial
                .map((item) => Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  menuMaxHeight: 200,
                                  items: material.map((material) {
                                    return DropdownMenuItem<String>(
                                      value: material['_id'],
                                      child: Text(
                                        material['name'] +
                                            " " +
                                            material['unit'],
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    item["name"] = value;
                                  },
                                ))),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: DropdownButtonFormField(
                              items: _value.map((vl) {
                                return DropdownMenuItem<String>(
                                  value: vl.toString(),
                                  child: Text(
                                    vl.toString(),
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                item["value"] = _dataSelection(value);
                              },
                              // value: typeName,
                            )),
                      ],
                    ))
                .toList(),
          )
        : Row();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add new product")),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Productname"),
                onChanged: (value) => {
                  name = value,
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Productcost"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) => {
                  cost = value,
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    child: const Text('add'),
                    onPressed: () {
                      _addSelection();
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    child: const Text('del'),
                    onPressed: () {
                      _deleteSelection();
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: const Text("name"),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: const Text("value"),
                  ),
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: _selectMaterial(),
              )),
              BlocListener<ProductBloc, ProductState>(
                listener: (context, state) {
                  if (state is ProductIsCreating) {
                    showLoaderDialog(context, 'is creating !');
                  }
                  if (state is ProductCreated) {
                    Navigator.pop(context);
                    showDialogResult(context, "Success");
                  }
                  if (state is ProductCreateFail) {
                    Navigator.pop(context);
                    showDialogResult(context, "Fail");
                  }
                },
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      OutlinedButton(
                        child: Text('create'),
                        onPressed: () {
                          if (name == '' || cost == '') {
                            showDialogResult(context, "check name and cost");
                          } else {
                            var params = {
                              "product": {
                                "name": name,
                                "cost": cost,
                                "status": widget.role.toString()
                              },
                              "materials": productMaterial
                            };
                            productBloc.add(ProductAdd(params: params));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
