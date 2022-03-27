import 'package:flutter/material.dart';

class ProductMenu extends StatelessWidget {
  const ProductMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product"),
        centerTitle: true,
      ),
      body: Container(child: Text("quan ly mon an")),
    );
  }
}
