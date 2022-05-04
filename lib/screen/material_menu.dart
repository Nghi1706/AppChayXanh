import 'dart:developer';

import 'package:chayxanhapp/const/data.dart';
import 'package:chayxanhapp/screen/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/material_bloc.dart';
import '../bloc/menu_bloc.dart';
import '../widget/button_manager.dart';

class MaterialMenu extends StatefulWidget {
  List listRestaurant;
  MaterialMenu({Key? key, required this.listRestaurant}) : super(key: key);

  @override
  State<MaterialMenu> createState() => _MaterialMenuState();
}

class _MaterialMenuState extends State<MaterialMenu> {
  MenuBloc menuBloc = MenuBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menuBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    String restaurantID = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Material",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => BlocProvider(
                        create: (context) => MaterialBloc(),
                        child: const MaterialCED(
                          isMaterialAll: true,
                          isMaterialRestaurant: false,
                        ),
                      ),
                    ));
              },
              child: const ButtonCustom(
                icon: Icons.other_houses_outlined,
                text: "Quản lý nguyên liệu chung",
              )),
          widget.listRestaurant.length == 0
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => BlocProvider(
                            create: (context) => MaterialBloc(),
                            child: const MaterialCED(
                              isMaterialAll: false,
                              isMaterialRestaurant: true,
                            ),
                          ),
                        ));
                  },
                  child: const ButtonCustom(
                    icon: Icons.other_houses,
                    text: "Nguyên liệu nhà hàng",
                  ))
              : InkWell(
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
                                            create: (context) => MaterialBloc(),
                                            child: const MaterialCED(
                                              isMaterialAll: false,
                                              isMaterialRestaurant: true,
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
                  child: const ButtonCustom(
                    icon: Icons.other_houses,
                    text: "Nguyên liệu nhà hàng",
                  ))
        ],
      ),
    );
  }
}
