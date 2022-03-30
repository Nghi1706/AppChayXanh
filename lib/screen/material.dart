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
    String typeName = 'gia vị';
    String unitName = 'kg';
    String materialName = '';
    String statusMaterial = 'Create material';
    return Scaffold(
        appBar: AppBar(
          title: const Text("Material"),
          centerTitle: true,
        ),
        body: isMaterialAll
            ? Container(
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: const [
                        Text(
                          "data",
                          style: TextStyle(fontSize: 50),
                        ),
                      ],
                    ),
                  )),
                  Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              statusMaterial,
                              style: TextStyle(fontSize: 20, color: Colors.red),
                            ),
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
            : Container(
                child: Text("CED Res material here !"),
              ));
  }
}
