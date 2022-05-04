import 'package:chayxanhapp/bloc/product_bloc.dart';
import 'package:chayxanhapp/screen/productInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';
import '../bloc/material_bloc.dart';
import '../bloc/menu_bloc.dart';
import '../screen/login.dart';
import '../screen/material_menu.dart';
import '../screen/product.dart';

class MenuManager extends StatelessWidget {
  final String restaurantName;
  final String restaurantAddress;
  final String restaurantUser;
  const MenuManager(
      {Key? key,
      required this.restaurantAddress,
      required this.restaurantUser,
      required this.restaurantName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(restaurantName),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => BlocProvider(
                            create: (context) => LoginBloc(),
                            child: const LoginScreen(),
                          ),
                        ),
                      )
                    },
                icon: Icon(Icons.logout))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    restaurantAddress,
                    style: const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.green,
                        fontWeight: FontWeight.w500),
                  ),
                  // decoration: BoxDecoration(
                  //     border: Border(
                  //         bottom:
                  //             BorderSide(width: 2, color: Colors.green))),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    restaurantUser,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 2, color: Colors.green))),
                ),
              ],
            ),
            Expanded(
                child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              padding: const EdgeInsets.all(70),
              children: [
                InkWell(
                  hoverColor: Colors.orange,
                  splashColor: Colors.red,
                  focusColor: Colors.yellow,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.other_houses_outlined,
                          size: 50,
                          color: Colors.black,
                        ),
                        Text("Material"),
                      ],
                    ),
                  ),
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => BlocProvider(
                            create: (context) => MenuBloc(),
                            child: MaterialMenu(
                              listRestaurant: [],
                            ),
                          ),
                        ));
                  },
                ),
                InkWell(
                    hoverColor: Colors.orange,
                    splashColor: Colors.red,
                    focusColor: Colors.yellow,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.food_bank_outlined,
                            size: 50,
                            color: Colors.black,
                          ),
                          Text("Product"),
                        ],
                      ),
                    ),
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => BlocProvider(
                              create: (context) => ProductBloc(),
                              child: const ProductScreen(
                                role: 1,
                              ),
                            ),
                          ));
                    }),
              ],
            ))
          ],
        ));
  }
}
