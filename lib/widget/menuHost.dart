// ignore_for_file: prefer_const_constructors

import 'package:chayxanhapp/bloc/employee_bloc.dart';
import 'package:chayxanhapp/screen/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/datarestaurant_bloc.dart';
import '../bloc/login_bloc.dart';
import '../bloc/material_bloc.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/product_bloc.dart';
import '../screen/cooking.dart';
import '../screen/login.dart';
import '../screen/material_menu.dart';
import '../screen/product.dart';

class MenuHost extends StatefulWidget {
  final String restaurantName;
  final String restaurantAddress;
  final String restaurantUser;
  final List listRestaurant;
  const MenuHost(
      {Key? key,
      required this.restaurantAddress,
      required this.restaurantUser,
      required this.restaurantName,
      required this.listRestaurant})
      : super(key: key);

  @override
  State<MenuHost> createState() => _MenuHostState();
}

class _MenuHostState extends State<MenuHost> {
  MenuBloc menuBloc = MenuBloc();
  EmployeeBloc employeeBloc = EmployeeBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menuBloc = BlocProvider.of(context);
    employeeBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    String restaurantID = '';
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
          title: Text(widget.restaurantName),
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
                    widget.restaurantAddress,
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
                    widget.restaurantUser,
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
                        Text("Restaurant"),
                      ],
                    ),
                  ),
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                                role: 2,
                              ),
                            ),
                          ));
                    }),
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
                          Icons.warehouse_outlined,
                          size: 50,
                          color: Colors.black,
                        ),
                        // ignore: prefer_const_constructors
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
                              listRestaurant: widget.listRestaurant,
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
                          Icons.people_outline,
                          size: 50,
                          color: Colors.black,
                        ),
                        // ignore: prefer_const_constructors
                        Text("Employee"),
                      ],
                    ),
                  ),
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          title: Text('Chọn nhà hàng'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text("Danh sách nhà hàng"),
                                const SizedBox(
                                  height: 10,
                                ),
                                DropdownButtonFormField(
                                  items:
                                      widget.listRestaurant.map((restaurant) {
                                    return DropdownMenuItem<String>(
                                      value: restaurant['_id'],
                                      child: Text(
                                        restaurant['name'],
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    restaurantID = value.toString();
                                  },
                                ),
                              ],
                            ),
                          ),
                          actionsOverflowButtonSpacing: 20,
                          actions: [
                            BlocListener<EmployeeBloc, EmployeeState>(
                              bloc: employeeBloc,
                              listener: (context, state) {
                                if (state is MenuEmployeeHostScreen) {
                                  if (state.status) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              BlocProvider(
                                            create: (context) => EmployeeBloc(),
                                            child: const EmployeeCED(
                                              role: 2,
                                            ),
                                          ),
                                        ));
                                  } else {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 248, 54, 40)),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)))),
                                ),
                                child: const Text("OK"),
                                onPressed: () {
                                  employeeBloc.add(EmployeeHostMenu(
                                      restaurantID: restaurantID));
                                },
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)))),
                              ),
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          title: Text('Chọn nhà hàng'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text("Danh sách nhà hàng"),
                                const SizedBox(
                                  height: 10,
                                ),
                                DropdownButtonFormField(
                                  items:
                                      widget.listRestaurant.map((restaurant) {
                                    return DropdownMenuItem<String>(
                                      value: restaurant['_id'],
                                      child: Text(
                                        restaurant['name'],
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    restaurantID = value.toString();
                                  },
                                ),
                              ],
                            ),
                          ),
                          actionsOverflowButtonSpacing: 20,
                          actions: [
                            BlocListener<MenuBloc, MenuState>(
                              bloc: menuBloc,
                              listener: (context, state) {
                                if (state is MenuMaterialHostScreen) {
                                  if (state.status) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              BlocProvider(
                                            create: (context) =>
                                                DatarestaurantBloc(),
                                            child: const CookingScreen(),
                                          ),
                                        ));
                                  } else {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 248, 54, 40)),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)))),
                                ),
                                child: const Text("OK"),
                                onPressed: () {
                                  menuBloc.add(MenuMaterialHost(
                                      RestaurantID: restaurantID));
                                },
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)))),
                              ),
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ))
          ],
        ));
  }
}
