import 'dart:developer';

import 'package:chayxanhapp/bloc/product_bloc.dart';
import 'package:chayxanhapp/const/data.dart';
import 'package:chayxanhapp/screen/productInfo.dart';
import 'package:chayxanhapp/widget/addProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatefulWidget {
  final int role;
  const ProductScreen({Key? key, required this.role}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductBloc productBloc = ProductBloc();
  List product = [];
  List material = [];
  @override
  void initState() {
    productBloc = BlocProvider.of(context);

    productBloc.add(ProductFetch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int role = widget.role;
    checkColor(String number) {
      int numberColor = int.parse(number);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product"),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                  child: BlocBuilder<ProductBloc, ProductState>(
                      bloc: productBloc,
                      builder: (context, state) {
                        if (state is ProductFetchState) {
                          product = state.product;
                          material = state.material;
                        }
                        return ListView.builder(
                            itemCount: product.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Card(
                                  color: checkColor(
                                      product[index]['status'].toString()),
                                  child: ListTile(
                                    title: Text(product[index]['name']),
                                    subtitle:
                                        Text(product[index]['cost'].toString()),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          BlocProvider(
                                        create: (context) => ProductBloc(),
                                        child: ProductInfo(
                                          idProduct: product[index]['_id'],
                                          role: role,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                      })),
              SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(),
                        ),
                        flex: 3,
                      ),
                      InkWell(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            margin: const EdgeInsets.only(right: 10),
                            child: const Text(
                              "New product",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      BlocProvider(
                                    create: (context) => ProductBloc(),
                                    child: AddProducts(
                                      material: material,
                                      role: role,
                                    ),
                                  ),
                                ));
                          }),
                    ],
                  )),
            ],
          )),
    );
  }
}
