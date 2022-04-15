import 'package:chayxanhapp/bloc/product_bloc.dart';
import 'package:chayxanhapp/const/data.dart';
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
    switch (widget.role) {
      case 0:
        productBloc.add(ProductCheck(role: 0));
        break;
      case 1:
        productBloc.add(ProductCheck(role: 1));
        break;
      case 2:
        productBloc.add(ProductCheck(role: 2));
        break;
      default:
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int role = widget.role;
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
                        if (state is ProductListScreenEmployee) {
                          product = state.product;
                          material = state.material;
                        }
                        return ListView.builder(
                            itemCount: product.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Text(index.toString()),
                              );
                            });
                      })),
              (role == 0)
                  ? Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(),
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
                                        ),
                                      ),
                                    ));
                              }),
                        ],
                      ))
                  : Container(),
            ],
          )),
    );
  }
}
