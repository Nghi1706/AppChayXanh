import 'dart:convert';
import 'dart:developer';

import 'package:chayxanhapp/api/callAPI.dart';
import 'package:chayxanhapp/widget/button_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api.dart';
import '../bloc/material_bloc.dart';

class MaterialCED extends StatefulWidget {
  final bool isMaterialAll;
  final bool isMaterialRestaurant;
  const MaterialCED(
      {Key? key,
      required this.isMaterialAll,
      required this.isMaterialRestaurant})
      : super(key: key);

  @override
  _MaterialCEDState createState() => _MaterialCEDState();
}

class _MaterialCEDState extends State<MaterialCED> {
  MaterialBloc materialBloc = MaterialBloc();
  @override
  void initState() {
    super.initState();
    materialBloc = BlocProvider.of(context);
    materialBloc.add(MaterialCheckEvent(
      isMaterialAll: widget.isMaterialAll,
      isMaterialRestaurant: widget.isMaterialRestaurant,
    ));
  }

  @override
  Widget build(BuildContext context) {
    bool isMaterialAll = widget.isMaterialAll;
    bool isMaterialrestaurant = widget.isMaterialRestaurant;
    List type = [];
    List unit = [];
    List material = [];
    String typeName = 'gia vị';
    String unitName = 'kg';
    String materialName = '';
    String materialEditName = '';
    String materialID = '';
    String materialEditStatus = 'Edit material';
    String statusMaterial = 'Create material';
    return Scaffold(
        appBar: AppBar(
          title: const Text("Material"),
          centerTitle: true,
        ),
        body: isMaterialAll
            // material all
            ? Container(
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  Expanded(
                    child: BlocBuilder<MaterialBloc, MaterialsState>(
                      bloc: materialBloc,
                      builder: (context, state) {
                        if (state is MaterialScreen) {
                          material = state.material;
                        }
                        return ListView.builder(
                          itemCount: material.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Card(
                                child: ListTile(
                                  title: Text(material[index]['name']),
                                  subtitle: Text(material[index]['type']),
                                ),
                              ),
                              onTap: () {
                                typeName = material[index]['type'];
                                materialEditName = material[index]['name'];
                                materialID = material[index]['_id'];
                                unitName = material[index]['unit'];
                                ;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BlocBuilder<MaterialBloc,
                                            MaterialsState>(
                                        bloc: materialBloc,
                                        builder: (context, state) {
                                          if (state is MaterialScreen) {
                                            type = state.type;
                                            unit = state.unit;
                                          }
                                          if (state is MaterialEditState) {
                                            materialEditStatus = state.message;
                                          }
                                          if (state is MaterialDeleteState) {
                                            materialEditStatus = state.message;
                                          }
                                          if (state
                                              is MaterialAddToRestaurantState) {
                                            materialEditStatus = state.message;
                                          }
                                          return AlertDialog(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            title: Text(materialEditStatus),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text("id_material"),
                                                  Text(materialID),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            materialEditName),
                                                    onChanged: (value) => {
                                                      materialEditName = value,
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text("Chọn loại nguyên liệu"),
                                                  DropdownButtonFormField(
                                                    items:
                                                        type.map((items_type) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value:
                                                            items_type['type'],
                                                        child: Text(
                                                          items_type['type'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      typeName =
                                                          value.toString();
                                                    },
                                                    value: typeName,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                      "Chọn đơn vị tính"),
                                                  DropdownButtonFormField(
                                                    items: unit.map((unit) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: unit['unit'],
                                                        child: Text(
                                                          unit['unit'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      unitName =
                                                          value.toString();
                                                    },
                                                    value: unitName,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actionsOverflowButtonSpacing: 20,
                                            actions: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color.fromARGB(255,
                                                              168, 196, 13)),
                                                  shape: MaterialStateProperty.all(
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)))),
                                                ),
                                                child: const Text(
                                                    "Add Restaurant"),
                                                onPressed: () {
                                                  materialBloc.add(MaterialAdd(
                                                      materialId: materialID));
                                                },
                                              ),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color.fromARGB(255,
                                                              248, 54, 40)),
                                                  shape: MaterialStateProperty.all(
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)))),
                                                ),
                                                child: const Text("Delete"),
                                                onPressed: () {
                                                  materialBloc.add(
                                                      MaterialDelete(
                                                          materialId:
                                                              materialID));
                                                  setState(() {
                                                    materialBloc
                                                        .add(MaterialCheckEvent(
                                                      isMaterialAll:
                                                          widget.isMaterialAll,
                                                      isMaterialRestaurant: widget
                                                          .isMaterialRestaurant,
                                                    ));
                                                  });
                                                },
                                              ),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                  shape: MaterialStateProperty.all(
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)))),
                                                ),
                                                child: const Text("Change"),
                                                onPressed: () {
                                                  materialBloc.add(MaterialEdit(
                                                      materialId: materialID,
                                                      materialName:
                                                          materialEditName,
                                                      materialType: typeName,
                                                      materialUnit: unitName));
                                                  setState(() {
                                                    materialBloc
                                                        .add(MaterialCheckEvent(
                                                      isMaterialAll:
                                                          widget.isMaterialAll,
                                                      isMaterialRestaurant: widget
                                                          .isMaterialRestaurant,
                                                    ));
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
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
                                  "New Material",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BlocBuilder<MaterialBloc,
                                            MaterialsState>(
                                        bloc: materialBloc,
                                        builder: (context, state) {
                                          if (state is MaterialScreen) {
                                            type = state.type;
                                            unit = state.unit;
                                          }
                                          if (state is MaterialCreateState) {
                                            statusMaterial = state.message;
                                          }
                                          return AlertDialog(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            title: Text(statusMaterial),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextField(
                                                    decoration: const InputDecoration(
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.green),
                                                        border:
                                                            OutlineInputBorder(),
                                                        label: Text(
                                                            "Material name")),
                                                    onChanged: (value) => {
                                                      materialName = value,
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text("Chọn loại nguyên liệu"),
                                                  DropdownButtonFormField(
                                                    items:
                                                        type.map((items_type) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value:
                                                            items_type['type'],
                                                        child: Text(
                                                          items_type['type'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      typeName =
                                                          value.toString();
                                                    },
                                                    value: typeName,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                      "Chọn đơn vị tính"),
                                                  DropdownButtonFormField(
                                                    items: unit.map((unit) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: unit['unit'],
                                                        child: Text(
                                                          unit['unit'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      unitName =
                                                          value.toString();
                                                    },
                                                    value: unitName,
                                                  ),
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
                                                                  Radius
                                                                      .circular(
                                                                          20)))),
                                                ),
                                                child: const Text("Create"),
                                                onPressed: () {
                                                  materialBloc.add(
                                                      MaterialCreate(
                                                          materialName:
                                                              materialName,
                                                          materialType:
                                                              typeName,
                                                          materialUnit:
                                                              unitName));
                                                  setState(() {
                                                    materialBloc
                                                        .add(MaterialCheckEvent(
                                                      isMaterialAll:
                                                          widget.isMaterialAll,
                                                      isMaterialRestaurant: widget
                                                          .isMaterialRestaurant,
                                                    ));
                                                  });
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
                ]),
              )
            // material restaurant
            : Container(
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  Expanded(
                    child: BlocBuilder<MaterialBloc, MaterialsState>(
                      bloc: materialBloc,
                      builder: (context, state) {
                        if (state is MaterialScreen) {
                          material = state.material;
                        }
                        return ListView.builder(
                          itemCount: material.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Card(
                                child: ListTile(
                                  title: Text(material[index]['name']),
                                  subtitle: Text(material[index]['type']),
                                ),
                              ),
                              onTap: () {
                                typeName = material[index]['type'];
                                materialEditName = material[index]['name'];
                                materialID = material[index]['_id'];
                                unitName = material[index]['unit'];
                                ;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BlocBuilder<MaterialBloc,
                                            MaterialsState>(
                                        bloc: materialBloc,
                                        builder: (context, state) {
                                          if (state is MaterialScreen) {
                                            type = state.type;
                                            unit = state.unit;
                                          }
                                          if (state is MaterialEditState) {
                                            materialEditStatus = state.message;
                                          }
                                          if (state is MaterialDeleteState) {
                                            materialEditStatus = state.message;
                                          }
                                          return AlertDialog(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            title: Text(materialEditStatus),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text("id_material"),
                                                  Text(materialID),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            materialEditName),
                                                    onChanged: (value) => {
                                                      materialEditName = value,
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text("Chọn loại nguyên liệu"),
                                                  DropdownButtonFormField(
                                                    items:
                                                        type.map((items_type) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value:
                                                            items_type['type'],
                                                        child: Text(
                                                          items_type['type'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      typeName =
                                                          value.toString();
                                                    },
                                                    value: typeName,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                      "Chọn đơn vị tính"),
                                                  DropdownButtonFormField(
                                                    items: unit.map((unit) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: unit['unit'],
                                                        child: Text(
                                                          unit['unit'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      unitName =
                                                          value.toString();
                                                    },
                                                    value: unitName,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actionsOverflowButtonSpacing: 20,
                                            actions: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color.fromARGB(255,
                                                              248, 54, 40)),
                                                  shape: MaterialStateProperty.all(
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)))),
                                                ),
                                                child: const Text("Delete"),
                                                onPressed: () {
                                                  materialBloc.add(
                                                      MaterialDelete(
                                                          materialId:
                                                              materialID));
                                                  setState(() {
                                                    materialBloc
                                                        .add(MaterialCheckEvent(
                                                      isMaterialAll:
                                                          widget.isMaterialAll,
                                                      isMaterialRestaurant: widget
                                                          .isMaterialRestaurant,
                                                    ));
                                                  });
                                                },
                                              ),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                  shape: MaterialStateProperty.all(
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)))),
                                                ),
                                                child: const Text("Change"),
                                                onPressed: () {
                                                  materialBloc.add(MaterialEdit(
                                                      materialId: materialID,
                                                      materialName:
                                                          materialEditName,
                                                      materialType: typeName,
                                                      materialUnit: unitName));
                                                  setState(() {
                                                    materialBloc
                                                        .add(MaterialCheckEvent(
                                                      isMaterialAll:
                                                          widget.isMaterialAll,
                                                      isMaterialRestaurant: widget
                                                          .isMaterialRestaurant,
                                                    ));
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
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
                                  "Add Material",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              onTap: () {}),
                        ],
                      )),
                ]),
              ));
  }
}
