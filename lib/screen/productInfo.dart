import 'dart:developer';

import 'package:chayxanhapp/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductInfo extends StatefulWidget {
  final String idProduct;
  final int role;
  const ProductInfo({Key? key, required this.idProduct, required this.role})
      : super(key: key);

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  ProductBloc productBloc = ProductBloc();
  String productName = '';
  String cost = '';
  List<DataRow> material = [];
  String comment = '';
  int status = 0;
  String commentBy = '';
  String _id = '';
  @override
  void initState() {
    productBloc = BlocProvider.of(context);
    super.initState();
    productBloc.add(ProductFetchMaterial(idProduct: widget.idProduct));
  }

  @override
  Widget build(BuildContext context) {
    final int role = widget.role;
    var data;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Product infomation"),
          centerTitle: true,
        ),
        body: Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  BlocListener<ProductBloc, ProductState>(
                    bloc: productBloc,
                    listener: (context, state) {
                      if (state is ProductFetching) {
                        showLoaderDialog(context, "Waiting...");
                      }
                      if (state is ProductFetchMaterialState) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(),
                  ),
                  BlocBuilder<ProductBloc, ProductState>(
                      bloc: productBloc,
                      builder: (context, state) {
                        if (state is ProductFetchMaterialState) {
                          data = state.data;
                          log(data.toString());
                          productName = data['Products']['name'];
                          cost = data['Products']['cost'];
                          status = int.parse(data['Products']['status']);
                          comment = data['Products']['comment'];
                          _id = data['Products']['Products'];
                          if (status == 1) {
                            commentBy = 'Manager';
                          } else if (status == 2) {
                            commentBy = 'Host';
                          }
                          for (var k = 0; k < data['Materials'].length; k++) {
                            material.add(DataRow(cells: [
                              DataCell(Text(data['Materials'][k]['name'])),
                              DataCell(Text(data['Materials'][k]['value'])),
                              DataCell(Text(data['Materials'][k]['unit'])),
                            ]));
                          }
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 20, top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Product name: ",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "  " + productName,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Product cost: ",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "  " + cost,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: DataTable(columns: const [
                                DataColumn(label: Text("Material name")),
                                DataColumn(label: Text("Value")),
                                DataColumn(label: Text("Unit")),
                              ], rows: material),
                            ),
                            status != 0
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Comment by: " + commentBy,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        comment,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )
                                : Container(),
                            (role != 0 && (role > status && status != -1))
                                ? Column(
                                    children: [
                                      Container(
                                        child: TextField(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'comment',
                                            ),
                                            maxLines: 3,
                                            onChanged: (value) {
                                              comment = value;
                                            }),
                                      ),
                                      BlocListener<ProductBloc, ProductState>(
                                          bloc: productBloc,
                                          listener: (context, state) {
                                            if (state is ProductIsUpdating) {
                                              showLoaderDialog(
                                                  context, "Loading !");
                                            }
                                            if (state is ProductUpdated) {
                                              Navigator.pop(context);
                                              showDialogResult(
                                                  context, "Success !");
                                            }
                                            if (state is ProductUpdateFail) {
                                              Navigator.pop(context);
                                              showDialogResult(
                                                  context, "Fail !");
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              OutlinedButton(
                                                  onPressed: () {
                                                    var params = {
                                                      "_id": widget.idProduct,
                                                      "status": role.toString(),
                                                      "comment": comment
                                                    };
                                                    productBloc.add(
                                                        ProductUpdate(
                                                            params: params));
                                                  },
                                                  child: const Text("accept")),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              OutlinedButton(
                                                  onPressed: () {
                                                    var params = {
                                                      "_id": widget.idProduct,
                                                      "status": "-1",
                                                      "comment": comment
                                                    };
                                                    productBloc.add(
                                                        ProductUpdate(
                                                            params: params));
                                                  },
                                                  child: const Text("deny")),
                                            ],
                                          ))
                                    ],
                                  )
                                : Row(),
                            role == 2
                                ? OutlinedButton(
                                    onPressed: () => {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      "Delete this Product"),
                                                  actions: [
                                                    OutlinedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text("No")),
                                                    BlocListener<ProductBloc,
                                                        ProductState>(
                                                      bloc: productBloc,
                                                      listener:
                                                          (context, state) {
                                                        log(state.toString());
                                                        if (state
                                                            is ProductIsDeleting) {
                                                          log("deleting !");

                                                          showLoaderDialog(
                                                              context,
                                                              "Deleting !");
                                                        }
                                                        if (state
                                                            is ProductDeleted) {
                                                          log("deleted !");
                                                          Navigator.pop(
                                                              context);
                                                          showDialogResult(
                                                              context,
                                                              "Deleted");
                                                        }
                                                        if (state
                                                            is ProductDeleteFail) {
                                                          log("delete fail !");
                                                          Navigator.pop(
                                                              context);
                                                          showDialogResult(
                                                              context, "fail");
                                                        }
                                                      },
                                                      child: OutlinedButton(
                                                          onPressed: () {
                                                            productBloc.add(
                                                                ProductDelete(
                                                                    params: {
                                                                  "id": _id
                                                                }));
                                                          },
                                                          child: const Text(
                                                              "Yes")),
                                                    )
                                                  ],
                                                );
                                              })
                                        },
                                    child: const Text("Delete"))
                                : Container()
                          ],
                        );
                      })
                ]))));
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
}
