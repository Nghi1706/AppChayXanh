import 'package:chayxanhapp/bloc/datarestaurant_bloc.dart';
import 'package:chayxanhapp/bloc/product_bloc.dart';
import 'package:chayxanhapp/screen/cooking.dart';
import 'package:chayxanhapp/screen/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';
import '../screen/login.dart';

class MenuEmployee extends StatelessWidget {
  final String restaurantName;
  final String restaurantAddress;
  final String restaurantUser;
  const MenuEmployee(
      {Key? key,
      required this.restaurantAddress,
      required this.restaurantUser,
      required this.restaurantName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    showDialogResult(BuildContext context, String data) {
      AlertDialog alert = AlertDialog(
        content: Text(data),
        actions: [
          OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("cancel")),
          OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => BlocProvider(
                      create: (context) => LoginBloc(),
                      child: const LoginScreen(),
                    ),
                  ),
                );
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

    return Scaffold(
        appBar: AppBar(
          title: Text(restaurantName),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => {showDialogResult(context, "Logout ?")},
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
                      children: [
                        Icon(
                          Icons.other_houses_outlined,
                          size: 50,
                          color: Colors.black,
                        ),
                        Text("Cooking"),
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
                            create: (context) => DatarestaurantBloc(),
                            child: const CookingScreen(),
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
                      children: [
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
                            child: const ProductScreen(role: 0),
                          ),
                        ));
                  },
                ),
              ],
            ))
          ],
        ));
  }
}
