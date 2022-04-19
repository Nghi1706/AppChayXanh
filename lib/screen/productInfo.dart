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
        body: BlocBuilder<ProductBloc, ProductState>(
            bloc: productBloc,
            builder: (context, state) {
              if (state is ProductFetchMaterialState) {
                data = state.data;
                log(data.toString());
                productName = data['Products']['name'];
                cost = data['Products']['cost'];
                status = int.parse(data['Products']['status']);
                comment = data['Products']['comment'];
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
              return (data != null)
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Column(
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
                                  Text(
                                    productName,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const Text(
                                    "Product cost: ",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    cost,
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
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'comment',
                                            ),
                                            maxLines: 3,
                                            onChanged: (value) {
                                              comment = value;
                                            }),
                                      ),
                                      Row(
                                        children: [
                                          OutlinedButton(
                                              onPressed: () {
                                                var params = {
                                                  "_id": widget.idProduct,
                                                  "status": role.toString(),
                                                  "comment": comment
                                                };
                                                productBloc.add(ProductUpdate(
                                                    params: params));
                                              },
                                              child: Text("accept")),
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
                                                productBloc.add(ProductUpdate(
                                                    params: params));
                                              },
                                              child: Text("denine"))
                                        ],
                                      )
                                    ],
                                  )
                                : Row(),
                          ],
                        ),
                      ))
                  : Container();
            }));
  }
}
