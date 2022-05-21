import 'dart:developer';

import 'package:chayxanhapp/bloc/restaurant_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Restaurant extends StatefulWidget {
  const Restaurant({Key? key}) : super(key: key);

  @override
  _RestaurantState createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  RestaurantBloc restaurantBloc = RestaurantBloc();
  String statusRestaurant = '';
  List dataRestaurant = [];
  List listManager = [];
  String restaurantName = '';
  String restaurantAddress = '';
  String idManager = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restaurantBloc = BlocProvider.of(context);
    restaurantBloc.add(FetchRestaurant());
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
      appBar: AppBar(
        title: const Text("Restaurant"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  log("ok");
                  restaurantBloc.add(FetchRestaurant());
                });
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                  child: BlocBuilder<RestaurantBloc, RestaurantState>(
                      bloc: restaurantBloc,
                      builder: (context, state) {
                        if (state is DataRestaurant) {
                          dataRestaurant = state.data;
                          listManager = state.listManager;
                        }
                        return ListView.builder(
                            itemCount: dataRestaurant.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Card(
                                  child: ListTile(
                                    title: Text(dataRestaurant[index]['name']),
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          title: Text(
                                              dataRestaurant[index]['name']),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text("Address :"),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(dataRestaurant[index]
                                                    ['address'])
                                              ],
                                            ),
                                          ),
                                        );
                                      });
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
                              "New restaurant",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            statusRestaurant = 'Create Restaurant';
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BlocBuilder<RestaurantBloc,
                                        RestaurantState>(
                                    bloc: restaurantBloc,
                                    builder: (context, state) {
                                      if (state is RestaurantCreate) {
                                        statusRestaurant = state.status;
                                      }

                                      return AlertDialog(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        title: Text(statusRestaurant),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextField(
                                                decoration:
                                                    const InputDecoration(
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.green),
                                                        border:
                                                            OutlineInputBorder(),
                                                        label: Text(
                                                            "Restaurant name")),
                                                onChanged: (value) => {
                                                  restaurantName = value,
                                                },
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                decoration: const InputDecoration(
                                                    labelStyle: TextStyle(
                                                        color: Colors.green),
                                                    border:
                                                        OutlineInputBorder(),
                                                    label: Text(
                                                        "Restaurant address")),
                                                onChanged: (value) => {
                                                  restaurantAddress = value,
                                                },
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              // Text("Select manager"),
                                              // DropdownButtonFormField(
                                              //     items: listManager
                                              //         .map((manager) {
                                              //       return DropdownMenuItem<
                                              //           String>(
                                              //         value: manager['_id'],
                                              //         child: Text(
                                              //           manager['name'],
                                              //           style: const TextStyle(
                                              //               color:
                                              //                   Colors.green),
                                              //         ),
                                              //       );
                                              //     }).toList(),
                                              //     onChanged: (value) {
                                              //       idManager =
                                              //           value.toString();
                                              //     }),
                                              // const SizedBox(
                                              //   height: 10,
                                              // ),
                                            ],
                                          ),
                                        ),
                                        actionsOverflowButtonSpacing: 20,
                                        actions: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)))),
                                            ),
                                            child: const Text("Create"),
                                            onPressed: () {
                                              if (restaurantName == '' ||
                                                  restaurantAddress == '') {
                                                showDialogResult(context,
                                                    "check info again !");
                                              } else {
                                                restaurantBloc.add(
                                                    CreateRestaurant(data: {
                                                  "name": restaurantName,
                                                  "address": restaurantAddress
                                                }, idManager: idManager));
                                                // setState(() {
                                                //   restaurantBloc
                                                //       .add(FetchRestaurant());
                                                // }
                                                // );
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                            );
                          }),
                    ],
                  )),
            ],
          )),
    );
  }
}
