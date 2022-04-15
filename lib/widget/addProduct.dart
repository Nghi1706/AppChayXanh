import 'dart:developer';

import 'package:chayxanhapp/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProducts extends StatefulWidget {
  List material = [];
  AddProducts({Key? key, required this.material}) : super(key: key);

  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  ProductBloc productBloc = ProductBloc();
  List<Widget> _selection = [];
  final List _value = [1, 2, 10, 20, 50, 100];
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

  Widget _selectMaterial() {
    List material = widget.material;
    return productMaterial.length > 0
        ? Column(
            children: productMaterial
                .map((item) => Row(
                      children: [
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
                                item["value"] = value;
                              },
                              // value: typeName,
                            )),
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
                                        material['name'],
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    item["name"] = value;
                                  },
                                )))
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
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: const Text("value"),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: const Text("name"),
                  )
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
                          var params = {
                            "product": {"name": name, "cost": cost},
                            "materials": productMaterial
                          };
                          productBloc.add(ProductAdd(params: params));
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
